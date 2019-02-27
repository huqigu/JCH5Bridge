//
//  JCH5Bridge.m
//  JCH5Bridge_Example
//  //🚀 ❌ ✅
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import "JCH5Bridge.h"
#import "JCH5BridgeModel.h"
#import "JCH5BridgeHandler.h"
@interface JCH5Bridge ()

@property (nonatomic,strong) JCH5BridgeModel *bridgeModel;

@property (nonatomic,strong) WKWebViewConfiguration *configuration;

@end

@implementation JCH5Bridge

- (WKWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
    }
    
    return _webView;
}

#pragma mark - Public Method

- (instancetype)initWithLogEnable:(BOOL)logEnable bridgeModel:(JCH5BridgeModel *)bridgeModel {
    if (self = [super init]) {
        self.logEnable = logEnable;
        self.bridgeModel = bridgeModel;
    }
    return self;
}


- (void)loadJavascriptCommand:(NSString *)javascriptCommand completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler {
    
    [self.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
    
}


#pragma mark - Private Method

- (WKWebViewConfiguration *)configuration {
    
    if (_configuration == nil) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        _configuration.userContentController = [[WKUserContentController alloc] init];
        _configuration.preferences = [[WKPreferences alloc] init];
        _configuration.preferences.javaScriptEnabled = YES;
        _configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        _configuration.allowsInlineMediaPlayback = YES;
    }
    
    return _configuration;
    
}

- (void)setBridgeModel:(JCH5BridgeModel *)bridgeModel {
    
    _bridgeModel = bridgeModel;
    
    if (bridgeModel.jsCode.length) {
        WKUserScript *script = [[WKUserScript alloc] initWithSource:bridgeModel.jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.configuration.userContentController addUserScript:script];
        
        NSLog(@"✅ addJsCode successed \n jsCode == %@",bridgeModel.jsCode);
    }
    
    
    if (bridgeModel.jsCookie.length) {
        WKUserScript * cookieScript = [[WKUserScript alloc]initWithSource:bridgeModel.jsCookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [self.configuration.userContentController addUserScript:cookieScript];
        
        NSLog(@"✅ addJsCookie successed \n jsCode == %@",bridgeModel.jsCookie);
    }
    
    
    if (bridgeModel.handlers) {
        for (JCH5BridgeHandler *handler in bridgeModel.handlers) {
            [self.configuration.userContentController addScriptMessageHandler:handler.handler name:handler.handlerName];
            
            NSLog(@"✅ addJsHandle successed \n handle == %@ & handleName == %@",NSStringFromClass([handler.handler class]),handler.handlerName);
        }
    }
}

@end
