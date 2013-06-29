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
- (void)voidDelegateMethodWithPrimitiveArgument:(int)argument;
- (void)voidDelegateMethodWithObjectArgument:(id)argument;

@end
