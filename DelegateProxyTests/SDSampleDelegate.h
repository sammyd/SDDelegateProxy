//
//  SDSampleDelegate.h
//  DelegateProxy
//
//  Created by Sam Davies on 29/06/2013.
//  Copyright (c) 2013 sammyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDSampleDelegate <NSObject>

@optional
- (void)voidDelegateMethod;
- (void)voidDelegateMethodWithArgument:(id)argument;

@end



/**
 This protocol is provided to force the compiler to compile method calls which
 don't exist on the object
 */
@protocol SDInvalidMethodProtocol <NSObject>

- (void)invalidVoidMethod;

@end