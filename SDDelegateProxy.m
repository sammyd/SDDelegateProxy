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

@end
