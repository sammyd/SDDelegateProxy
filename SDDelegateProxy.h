//
//  SDDelegateProxy.h
//  DelegateProxy
//
//  Created by Sam Davies on 29/06/2013.
//  Copyright (c) 2013 sammyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDelegateProxy : NSProxy

@property (readonly, weak, nonatomic) id delegate;

- (id)initWithDelegate:(id)delegate;

@end
