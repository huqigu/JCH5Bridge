//
//  JCViewController.m
//  JCH5Bridge
//
//  Created by huqigu on 02/27/2019.
//  Copyright (c) 2019 huqigu. All rights reserved.
//

#import "JCViewController.h"
#import "JCH5Bridge.h"
#import "JCH5BridgeHandler.h"
#import "JCH5BridgeModel.h"
#import <WebKit/WebKit.h>
@interface JCViewController ()<WKScriptMessageHandler>

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    static  NSString * const jsCode =
    @"function readCookie(){\
    var x = document.cookie;\
    alert(x);\
    return x;\
    };function jsCallOc(){\
    window.webkit.messageHandlers.methodName1.postMessage(\"this is message1\");\
    window.webkit.messageHandlers.methodName2.postMessage(\"this is message2\");\
    };";
    
    
    JCH5BridgeHandler *handler1 = [[JCH5BridgeHandler alloc] initWithHandler:self handlerName:@"methodName1"];
    
    JCH5BridgeHandler *handler2 = [[JCH5BridgeHandler alloc] initWithHandler:self handlerName:@"methodName2"];
    
    
    JCH5BridgeModel *model = [[JCH5BridgeModel alloc] initWithJsCode:jsCode jsCookieDict:@{@"username":@"jc",@"password":@"123"} handlers:@[handler1,handler2]];
    
    
    JCH5Bridge *bridge = [[JCH5Bridge alloc] initWithLogEnable:YES bridgeModel:model];
    
    
    WKWebView *webView = [bridge webView];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSMutableURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"]]];
    
    
    // 这是为了调用js的方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [bridge loadJavascriptCommand:@"readCookie()" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            
            [bridge loadJavascriptCommand:@"jsCallOc()" completionHandler:nil];
            
        }];
        
    });
    
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"methodName1"]) {
        NSLog(@"%@", message.body);
    }
    
    if ([message.name isEqualToString:@"methodName2"]) {
        NSLog(@"%@", message.body);
    }
}
@end
