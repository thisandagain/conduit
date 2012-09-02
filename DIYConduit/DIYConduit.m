//
//  DIYConduit.m
//  conduit
//
//  Created by Andrew Sliwinski on 6/17/12.
//  Copyright (c) 2012 DIY, Co. All rights reserved.
//

#import "DIYConduit.h"

//

@interface DIYConduit ()
@property (nonatomic, retain) DIYConduitBridge *bridge;
@property (readwrite) NSMutableDictionary *headers;
@end

//

@implementation DIYConduit

#pragma mark - Init

- (void)_init
{
    // Setup
    _webView        = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bridge         = [[DIYConduitBridge alloc] init];
    _headers        = [[NSMutableDictionary alloc] init];
    
    // Assign delegates
    self.bridge.delegate     = self;
    self.webView.delegate    = self.bridge;
    
    // Add to view
    [self addSubview:self.webView];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

#pragma mark - Public methods

/**
 * Loads a NSURLRequest into the web view with custom headers appended.
 *
 * @param {NSURLRequest} Request
 *
 * @return {void}
 */
- (void)loadRequest:(NSURLRequest *)request
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        [self.webView loadRequest:[self generateMutableRequestWithRequest:request andHeaders:self.headers]];
        [self.bridge pushRequestHeaders:self.headers];
    });
}

/**
 * Loads HTML into the web view from a string.
 *
 * @param {NSString} HTML
 * @param {NSURL} Base URL reference (usually set to "nil")
 *
 * @return {void}
 */
- (void)loadHTMLString:(NSString *)html baseURL:(NSURL *)baseURL
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        [self.webView loadHTMLString:html baseURL:baseURL];
    });
}

/**
 * Adds a custom header to be reflected in every subsequent request.
 *
 * @param {NSString} Header key (e.g. @"x-api-key")
 * @param {NSString} Header value (e.g. @"mykeygoeshere")
 *
 * @return {void}
 */
- (void)addHeader:(NSString *)key withValue:(NSString *)value
{
    [self.headers setValue:value forKey:[key lowercaseString]];
}

/**
 * Removes a header.
 *
 * @param {NSString} Header key (e.g. @"x-api-key")
 *
 * @return {void}
 */
- (void)removeHeader:(NSString *)key
{
    [self.headers setValue:nil forKey:[key lowercaseString]];
}

/**
 * Sends a message to the bridge.
 *
 * @param {NSString} Message
 *
 * @return {void}
 */
- (void)sendMessage:(NSString *)message
{
    [self.bridge sendMessage:message toWebView:self.webView];
}

/**
 * Resets the bridge message queue.
 *
 * @return {void}
 */
- (void)resetMessageQueue
{
    [bridge resetQueue];
}

#pragma mark - Private methods

- (NSMutableURLRequest *)generateMutableRequestWithRequest:(NSURLRequest *)_request andHeaders:(NSDictionary *)_headers
{
    NSMutableURLRequest *mutableRequest = [_request mutableCopy];
    for (NSString *key in self.headers) {
        [mutableRequest setValue:[self.headers valueForKey:key] forHTTPHeaderField:key];
    }
    
    return mutableRequest;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Check for local request & bypass custom headers logic
    if ([[[request URL] absoluteString] isEqualToString:@"about:blank"]) {
        return true;
    }
    
    // Storage objects
    BOOL customHeadersExist         = true;
    NSDictionary *existingHeaders   = [request allHTTPHeaderFields];
    
    // Check that custom headers exist
    for (NSString *key in self.headers) {
        if ([existingHeaders objectForKey:key] == nil) {
            customHeadersExist = false;
            break;
        }
    }
    
    // If not, append them to the request
    if (!customHeadersExist) {
        [self loadRequest:request];
        return false;
    }
    
    return true;
}

#pragma mark - WebViewJavascriptBridge

- (void)javascriptBridge:(DIYConduitBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView
{
    [self.delegate conduit:self receivedMessage:message];
}

#pragma mark - Dealloc

- (void)dealloc
{
    self.delegate = nil;
    
    _webView = nil;
    _bridge = nil;
    _headers = nil;
}

@end