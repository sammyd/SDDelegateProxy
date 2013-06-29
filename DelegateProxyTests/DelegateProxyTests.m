//
//  DelegateProxyTests.m
//  DelegateProxyTests
//
//  Created by Sam Davies on 29/06/2013.
//  Copyright (c) 2013 sammyd. All rights reserved.
//

#import "DelegateProxyTests.h"
#import "SDDelegateProxy.h"
#import "SDSampleDelegate.h"
#import "SDSampleDelegateImplementation.h"
#import <OCMock/OCMock.h>

@implementation DelegateProxyTests {
    OCMockObject<SDSampleDelegate> *mockDelegate;
    id<SDSampleDelegate> sampleFullDelegate;
    id<SDSampleDelegate> sampleEmptyDelegate;
    id<SDSampleDelegate> delegateProxy;
    id<SDSampleDelegate> emptyDelegateProxy;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SDSampleDelegate)];
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:mockDelegate];
    sampleEmptyDelegate = [[SDSampleDelegateEmptyImplementation alloc] init];
    sampleFullDelegate = [[SDSampleDelegateFullImplementation alloc] init];
    emptyDelegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:sampleEmptyDelegate];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


#pragma mark - Initialisation
- (void)test_CanCreateProxy
{
    SDDelegateProxy *proxy = [[SDDelegateProxy alloc] initWithDelegate:mockDelegate];
    STAssertNotNil(proxy, @"Can create delegate proxy");
}

- (void)test_CreatingProxyStoresReferenceToDelegate
{
    SDDelegateProxy *proxy = [[SDDelegateProxy alloc] initWithDelegate:mockDelegate];
    STAssertEquals(proxy.delegate, mockDelegate, @"Constructor should correctly keep reference to delegate");
}

- (void)test_CreateProxyWithNilDelegateThrows
{
    STAssertThrows([[SDDelegateProxy alloc] initWithDelegate:nil], @"It shouldn't be possible to create a proxy of a nil object");
}


#pragma mark - Void Methods
- (void)test_InvalidVoidMethod_ShouldNotRespondToSelector
{
    STAssertFalse([delegateProxy respondsToSelector:@selector(invalidMethod)], @"respondsToSelector should be NO for invalid methods");
}

- (void)test_ValidVoidMethod_WithImplementation_ShouldRespondToSelector
{
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:sampleFullDelegate];
    STAssertTrue([delegateProxy respondsToSelector:@selector(voidDelegateMethod)], @"respondsToSelector should be YES for valid methods with implementations");
}

- (void)test_ValidVoidMethod_WithoutImplementation_ShouldNotRespondToSelector
{
    STAssertFalse([emptyDelegateProxy respondsToSelector:@selector(voidDelegateMethod)], @"respondsToSelector should be NO for valid methods without implementations");
}

- (void)test_InvalidVoidMethod_ShouldThrow
{
    STAssertThrows([(id<SDInvalidMethodProtocol>)delegateProxy invalidVoidMethod], @"Invalid void method should throw");
}

- (void)test_ValidVoidMethod_WithoutImplementation_ShouldNotThrow
{
    // Can't do this one with a mock. Let's use our sample implementation
    STAssertNoThrow([emptyDelegateProxy voidDelegateMethod], @"Non-implemented valid void method should not throw");
}

- (void)test_ValidVoidMethod_WithImplementation_ShouldNotThrow
{
    [[mockDelegate expect] voidDelegateMethod];
    STAssertNoThrow([delegateProxy voidDelegateMethod], @"Implemented valid void method should not throw");
    [mockDelegate verify];
}

#pragma mark - void methods with arguments
- (void)test_ValidVoidMethodWithArgument_WithImplementation_ShouldPassArgumentCorrectly
{
    [[mockDelegate expect] voidDelegateMethodWithArgument:self];
    STAssertNoThrow([delegateProxy voidDelegateMethodWithArgument:self], @"Arguments should be passed through correctly");
    [mockDelegate verify];
}

#pragma mark - Non-void return types
- (void)test_ObjectReturnType_Implemented_ReturnsCorrectObject
{
    [[[mockDelegate expect] andReturn:self] delegateMethodWithObjectReturnType];
    STAssertEquals(self, [delegateProxy delegateMethodWithObjectReturnType], @"Implemented object return should proxy");
    [mockDelegate verify];
}

- (void)test_ObjectReturnType_NotImplemented_ReturnsNil
{
    STAssertNil([emptyDelegateProxy delegateMethodWithObjectReturnType], @"Not-implemented object return should be nil");
}

- (void)test_IntegerReturnType_Implemented_ReturnsCorrectValue
{
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE((int){12})] delegateMethodWithIntegerReturnType];
    STAssertEquals((int)12, [delegateProxy delegateMethodWithIntegerReturnType], @"Implemented int return should proxy");
    [mockDelegate verify];
}

- (void)test_IntegerReturnType_NotImplemeted_ReturnsZero
{
    STAssertEquals((int)0, [emptyDelegateProxy delegateMethodWithIntegerReturnType], @"Not-implemented integer return should be 0");
}

- (void)test_FloatReturnType_Implemented_ReturnsCorrectValue
{
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE((float){3.5})] delegateMethodWithFloatReturnType];
    STAssertEquals((float)3.5, [delegateProxy delegateMethodWithFloatReturnType], @"Implemented float return should proxy");
    [mockDelegate verify];
}

- (void)test_FloatReturnType_NotImplemented_ReturnsZero
{
    STAssertTrue([emptyDelegateProxy delegateMethodWithFloatReturnType] == 0, @"Not-implemented float should return 0");
}

- (void)test_StructReturnType_NotImplemented_ReturnsEmptyStruct
{
    STAssertTrue(CGPointEqualToPoint([emptyDelegateProxy delegateMethodWithStructReturnType], CGPointMake(0, 0)), @"Not-implemented struct return type returns struct with appropriate empty values");
}

- (void)test_BoolReturnType_Implemented_ReturnsCorrectValue
{
    [[[mockDelegate expect] andReturnValue:OCMOCK_VALUE((BOOL){YES})] delegateMethodWithBoolReturnType];
    STAssertTrue([delegateProxy delegateMethodWithBoolReturnType], @"Implemneted BOOL return should proxy");
    [mockDelegate verify];
}

- (void)test_BoolReturnType_NotImplemented_ReturnsNo
{
    STAssertFalse([emptyDelegateProxy delegateMethodWithBoolReturnType], @"Default value for boolean return type should be NO");
}

@end
