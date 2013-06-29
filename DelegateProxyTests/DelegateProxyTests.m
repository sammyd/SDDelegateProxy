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
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    mockDelegate = [OCMockObject mockForProtocol:@protocol(SDSampleDelegate)];
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:mockDelegate];
    sampleEmptyDelegate = [[SDSampleDelegateEmptyImplementation alloc] init];
    sampleFullDelegate = [[SDSampleDelegateFullImplementation alloc] init];
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
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:sampleEmptyDelegate];
    STAssertFalse([delegateProxy respondsToSelector:@selector(voidDelegateMethod)], @"respondsToSelector should be NO for valid methods without implementations");
}

- (void)test_InvalidVoidMethod_ShouldThrow
{
    STAssertThrows([(id<SDInvalidMethodProtocol>)delegateProxy invalidVoidMethod], @"Invalid void method should throw");
}

- (void)test_ValidVoidMethod_WithoutImplementation_ShouldNotThrow
{
    // Can't do this one with a mock. Let's use our sample implementation
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:sampleEmptyDelegate];
    STAssertNoThrow([delegateProxy voidDelegateMethod], @"Non-implemented valid void method should not throw");
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
    STAssertNoThrow([delegateProxy voidDelegateMethodWithArgument:self], @"");
    [mockDelegate verify];
}


@end
