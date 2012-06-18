//
//  DIYViewController.m
//  conduit
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import "DIYViewController.h"

@implementation DIYViewController

@synthesize conduit;
@synthesize objcToJsButton;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    
    [conduit setDelegate:self];
    [conduit addHeader:@"x-some-header" withValue:@"foo"];
    [conduit removeHeader:@"x-some-other-header"];
    [conduit loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://my.awesomecat.com/"]]];
    
    [self renderWebView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Render

- (void)renderWebView
{
    [conduit loadHTMLString:@""
     "<!doctype html>"
     "<html><head>"
     "  <style type='text/css'>body { font-family: Helvetica; } h1 { color:#333; }</style>"
     "</head><body>"
     "  <h1>Conduit Demo</h1>"
     "  <script>"
     "  document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false);"
     "  function onBridgeReady() {"
     "      WebViewJavascriptBridge.setMessageHandler(function(message) {"
     "          var el = document.body.appendChild(document.createElement('div'));"
     "          el.innerHTML = message;"
     "      });"
     "      WebViewJavascriptBridge.sendMessage('hello from the JS');"
     "      var button = document.body.appendChild(document.createElement('button'));"
     "      button.innerHTML = 'Click me to send a message to ObjC';"
     "      button.onclick = button.ontouchup = function() { WebViewJavascriptBridge.sendMessage('hello from JS button'); };"
     "  }"
     "  </script>"
     "</body></html>" baseURL:nil];
}

#pragma mark - UI events

- (IBAction)sendMessage:(id)sender
{
    [conduit sendMessage:@"hello from Objective-C button"];
}

#pragma mark - Conduit Delegate

- (void)conduit:(DIYConduit *)conduit receivedMessage:(NSString *)message
{
    NSLog(@"%@", message);
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    [conduit release]; conduit = nil;
    [objcToJsButton release]; objcToJsButton = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseObjects];
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end