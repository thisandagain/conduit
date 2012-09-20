//
//  DIYConduit.h
//  conduit
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIYConduitBridge.h"

@class DIYConduit;

//

@protocol DIYConduitDelegate
- (void)conduit:(DIYConduit *)conduit receivedMessage:(NSString *)message;
@end

//

@interface DIYConduit : UIView <DIYConduitBridgeDelegate>
{
    @private DIYConduitBridge *_conduitBridge;
}

@property id <DIYConduitDelegate> delegate;
@property UIWebView *webView;
@property (readonly) NSMutableDictionary *headers;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)html baseURL:(NSURL *)baseURL;

- (void)addHeader:(NSString *)key withValue:(NSString *)value;
- (void)removeHeader:(NSString *)key;

- (void)sendMessage:(NSString *)message;
- (void)resetMessageQueue;

@end