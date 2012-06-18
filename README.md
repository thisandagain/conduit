## Conduit
#### JS to Objective-C... and back again

DIYConduit was created to address three pain points present within many iOS applications that rely on UIWebView: 
- Communication from Javascript to Objective-C
- Communication from Objective-C to Javascript
- Handling custom HTTP headers between multiple requests 

DIYConduit simply wraps these three pieces of functionality into a nice little library with a simple API and lets you go on about your business.

## Basic Use
The fastest way to get up and running with DIYConduit is to take a look at the included example application. The XCode project file can be found in `example > conduit.xcodeproj`. But for those of you that put on your adventure pants today... read ahead:

YourViewController.h
```objective-c
#import <UIKit/UIKit.h>
#import "DIYConduit.h"

@interface YourViewController : UIViewController <DIYConduitDelegate>
@property (nonatomic, retain) IBOutlet DIYConduit *conduit;
@end
```

YourViewController.m
```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [conduit setDelegate:self];
    [conduit loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://my.awesomecats.com/index.html"]]];
}

- (void)conduit:(DIYConduit *)conduit receivedMessage:(NSString *)message
{
    NSLog(@"%@", message);
}
```

index.html
```html
<!doctype html>
<html>
    <head>
        <style type='text/css'>body { font-family: Helvetica; } h1 { color:#333; }</style>
    </head>
    <body>
        <h1>Conduit Demo</h1>

        <script>
            document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false);
            function onBridgeReady() {
                WebViewJavascriptBridge.setMessageHandler(function(message) {
                    var el = document.body.appendChild(document.createElement('div'));
                    el.innerHTML = message;
                });
                
                WebViewJavascriptBridge.sendMessage('hello from the JS');
                var button = document.body.appendChild(document.createElement('button'));
                button.innerHTML = 'Click me to send a message to ObjC';
                button.onclick = button.ontouchup = function() { WebViewJavascriptBridge.sendMessage('hello from JS button'); };
            }
        </script>
    </body>
</html>
```

## JS to Objective-C
Communication from JS to Objective-C is handled by the `sendMessage` function on the `WebViewJavascriptBridge` object. The function should only be called after the `WebViewJavascriptBridgeReady` event.
```javascript
document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false);
function onBridgeReady() {
    WebViewJavascriptBridge.sendMessage('Hello from the magical land of Javascript. Unicorns! Rainbows! Robots! Substack!');
}
```

Receipt of messages from JS is handled through the use of a delegate method.
```objective-c
- (void)conduit:(DIYConduit *)conduit receivedMessage:(NSString *)message
{
    NSLog(@"%@", message);
}
```

## Objective-C to JS
Communication from Objective-C to JS is handled by the `sendMessage` method. This method can be invoked at any time, though messages will be queued until received by the web view.
```objective-c
[conduit sendMessage:@"Hello from Objective-C. *Beep* *Buzz* ... *Ding!*"];
```

Similar to how messages are sent from JS, messages are received after the `WebViewJavascriptBridgeReady` has been called via the `setMessageHandler`.
```javascript
document.addEventListener('WebViewJavascriptBridgeReady', onBridgeReady, false);
function onBridgeReady() {
    WebViewJavascriptBridge.setMessageHandler(function (message) {
        alert(message);
    });
}
```

## Custom HTTP Headers
Custom headers can be a bit of a pain when using a vanilla UIWebView, so DIYConduit provides convenience methods for creating and removing custom headers while persisting them through requests. Headers can be added and removed at will and will immediately reflected and persisted starting with the next HTTP request. 

```objective-c
[conduit addHeader:@"x-some-header" withValue:@"foo"];
[conduit removeHeader:@"x-something-else"];
```

---

## Methods
```objective-c
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)html baseURL:(NSURL *)baseURL;
- (void)addHeader:(NSString *)key withValue:(NSString *)value;
- (void)removeHeader:(NSString *)key;
- (void)sendMessage:(NSString *)message;
- (void)resetMessageQueue;
```

## Delegate Methods
```objective-c
- (void)conduit:(DIYConduit *)conduit receivedMessage:(NSString *)message;
```

## Properties
```objective-c
@property (nonatomic, assign) id <DIYConduitDelegate> delegate;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableDictionary *headers;
```

---

## ARC
ARC is not supported at this time. It is most certainly on the big 'ol "to-do" list though.

## Credits
Conduit's Objective-C to JS bridge is based on [WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge) by Marcus Westin, Stepan Generalov and Sergio Campamá. 