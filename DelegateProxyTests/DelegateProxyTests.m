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

@implementation DelegateProxyTests {
    id<SDSampleDelegate> sampleDelegate;
    id<SDSampleDelegate> delegateProxy;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    sampleDelegate = [[SDSampleDelegateImplementation alloc] init];
    delegateProxy = (id<SDSampleDelegate>)[[SDDelegateProxy alloc] initWithDelegate:sampleDelegate];
}

- (void)tearDown
{
    // Tear-down code here.
    sampleDelegate = nil;
    
    [super tearDown];
}


#pragma mark - Initialisation
- (void)test_CanCreateProxy
{
    SDDelegateProxy *proxy = [[SDDelegateProxy alloc] initWithDelegate:sampleDelegate];
    STAssertNotNil(proxy, @"Can create delegate proxy");
}

- (void)test_CreatingProxyStoresReferenceToDelegate
{
    SDDelegateProxy *proxy = [[SDDelegateProxy alloc] initWithDelegate:sampleDelegate];
    STAssertEquals(proxy.delegate, sampleDelegate, @"Constructor should correctly keep reference to delegate");
}


#pragma mark - Void Methods



@end
