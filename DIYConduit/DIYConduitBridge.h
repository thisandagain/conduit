//
//  DIYConduitBridge.h
//  conduit
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Based on WebViewJavascriptBridge by Marcus Westin, Stepan Generalov and Sergio Campamá.
//

#import <UIKit/UIKit.h>

@class DIYConduitBridge;

//

@protocol DIYConduitBridgeDelegate <UIWebViewDelegate>
- (void)javascriptBridge:(DIYConduitBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView;
@end

//

@interface DIYConduitBridge : NSObject <UIWebViewDelegate>

@property (nonatomic, assign) id <DIYConduitBridgeDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *requestHeaders;

- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView;
- (void)resetQueue;
- (void)pushRequestHeaders:(NSMutableDictionary *)headers;

@end