SDDelegateProxy
===============

When writing code which uses delegates you'll be used to this pattern:

    if([delegate respondsToSelector:@selector(someMethodName)]) {
        [delegate someMethodName];
    }

In a large project this happens time and time again. `SDDelegateProxy` is the fix. It proxies the delegate object and passes the messages it can.

To create a delegate proxy:

    id<DelegateProtocol> delegateProxy = (id<DelegateProtocol>)[[SDDelegateProxy alloc] initWithDelegate:delegate];

And then to use it:

    [delegateProxy someMethodName];


## How to use

Simply pull `SDDelegateProxy.m` and `SDDelegateProxy.h` into your project and use the two code snippets above. You can message the proxy with any of the selectors defined in the delegate protocol. Attempting to send other selectors will result in a NotImplemented exception. Sending a message to method which is on the protocol, but is not implemented on the delegate object will not result in a error, and will return sensible defaults if appropriate.


## Non-void return values

Obviously for void delegate methods, if they're not implemented on the delegate object the proxy can just swallow the invocation. However, this isn't true if you're expecting a return value. The following default return values are used:


| Type      | Default Value  |
| --------- |--------------- |
| id        | `nil`          |
| NSInteger | `0`            |
| CGFloat   | `0.0`          |
| BOOL      | `NO`           |


## Motivation

Used this in several projects to stop having to write the `respondsToSelector` if statement. Finally decided to open source it as part of Objective-C Hackathon https://objectivechackathon.appspot.com/