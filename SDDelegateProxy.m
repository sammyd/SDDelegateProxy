//
//  SDDelegateProxy.m
//  DelegateProxy
//
//  Created by Sam Davies on 29/06/2013.
//  Copyright (c) 2013 sammyd. All rights reserved.
//

#import "SDDelegateProxy.h"

@implementation SDDelegateProxy

- (id)initWithDelegate:(id)delegate
{
    if(self) {
        _delegate = delegate;
    }
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{    
    // Let's ask the delegate
    return [self.delegate respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.delegate methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    if([self.delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.delegate];
    }
}

@end
