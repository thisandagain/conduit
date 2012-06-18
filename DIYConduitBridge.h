#import <UIKit/UIKit.h>

@class DIYConduitBridge;

//

@protocol DIYConduitBridgeDelegate <UIWebViewDelegate>
- (void)javascriptBridge:(DIYConduitBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView;
@end

//

@interface DIYConduitBridge : NSObject <UIWebViewDelegate>

@property (nonatomic, assign) IBOutlet id <DIYConduitBridgeDelegate> delegate;

+ (id)javascriptBridgeWithDelegate:(id <DIYConduitBridgeDelegate>)delegate;
- (void)sendMessage:(NSString *)message toWebView:(UIWebView *)webView;
- (void)resetQueue;

@end