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
@end

//

@implementation DIYConduit

@synthesize delegate;
@synthesize webView;
@synthesize bridge;
@synthesize headers;

#pragma mark - Init

- (void)_init
{
    // Setup
    self.webView        = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.bridge         = [[DIYConduitBridge alloc] init];
    self.headers        = [[NSMutableDictionary alloc] init];
    
    // Assign delegates
    bridge.delegate     = self;
    webView.delegate    = bridge;
    
    // Add to view
    [self addSubview:webView];
}

- (id)init
{
    if (self = [super init])
    {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
	if (self = [super initWithFrame:frame]) 
    {
		[self _init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
	if (self = [super initWithCoder:aDecoder])
    {
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
    [webView loadRequest:[self generateMutableRequestWithRequest:request andHeaders:headers]];
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
    [webView loadHTMLString:html baseURL:baseURL];
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
    [headers setValue:value forKey:[key lowercaseString]];
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
    [headers setValue:nil forKey:[key lowercaseString]];
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
    [bridge sendMessage:message toWebView:webView];
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
    NSMutableURLRequest *mutableRequest = [[_request mutableCopy] autorelease];
    for (NSString *key in headers)
    {
        [mutableRequest setValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    
    return mutableRequest;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // Check for local request & bypass custom headers logic
    if ([[[request URL] absoluteString] isEqualToString:@"about:blank"])
    {
        return true;
    }
    
    // Storage objects
    BOOL customHeadersExist         = true;
    NSDictionary *existingHeaders   = [request allHTTPHeaderFields];
    
    // Check that custom headers exist
    for (NSString *key in headers)
    {
        if ([existingHeaders objectForKey:key] == nil)
        {
            customHeadersExist = false;
            break;
        }
    }
    
    // If not, append them to the request
    if (!customHeadersExist)
    {
        [self loadRequest:request];
        return false;
    }
    
    return true;
}

#pragma mark - WebViewJavascriptBridge

- (void)javascriptBridge:(DIYConduitBridge *)bridge receivedMessage:(NSString *)message fromWebView:(UIWebView *)webView
{
    [delegate conduit:self receivedMessage:message];
}

#pragma mark - Dealloc

- (void)releaseObjects
{
    delegate = nil;
    
    [webView release]; webView = nil;
    [bridge release]; bridge = nil;
    [headers release]; headers = nil;
}

- (void)dealloc
{
    [self releaseObjects];
    [super dealloc];
}

@end