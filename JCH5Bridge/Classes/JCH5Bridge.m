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
@interface JCH5Bridge ()<WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) JCH5BridgeModel *bridgeModel;

@property (nonatomic,strong) WKWebView *webView;

@property (nonatomic,strong) UIProgressView *progressView;

@property (nonatomic,strong) WKWebViewConfiguration *configuration;

@end

@implementation JCH5Bridge

#pragma mark - Public Method

- (instancetype)initWithLogEnable:(BOOL)logEnable progressEnable:(BOOL)progressEnable bridgeModel:(nonnull JCH5BridgeModel *)bridgeModel {
    if (self = [super init]) {
        self.logEnable = logEnable;
        self.progressEnable = progressEnable;
        self.bridgeModel = bridgeModel;
    }
    return self;
}

- (void)loadUrl:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)loadJavascriptCommand:(NSString *)javascriptCommand completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler {
    
    [self.webView evaluateJavaScript:javascriptCommand completionHandler:handler];
    
}

#pragma mark - Getter & Setter

- (WKWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
        
        _webView.UIDelegate = self;
        // 加载进度条
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return _webView;
}

- (UIProgressView *)progressView {
    
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor  = [UIColor clearColor];
        _progressView.trackTintColor   = [UIColor clearColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _progressView;
}

- (void)setWebViewController:(UIViewController *)webViewController {
    
    _webViewController = webViewController;
    
    
    self.webView.frame = webViewController.view.bounds;
    [webViewController.view addSubview:self.webView];
    
    // 添加progressView
    CGFloat progressY = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if (webViewController.navigationController) {
        progressY += webViewController.navigationController.navigationBar.frame.size.height;
    }
    self.progressView.frame = CGRectMake(0, progressY, [UIScreen mainScreen].bounds.size.width, 2.0f);
    [webViewController.view addSubview:self.progressView];
    [webViewController.view bringSubviewToFront:self.progressView];
}

- (void)setProgressEnable:(BOOL)progressEnable {
    
    _progressEnable = progressEnable;
    
    self.progressView.hidden = !progressEnable;
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
        
        if (self.logEnable) {
            NSLog(@"✅ addJsCode successed \n jsCode == %@",bridgeModel.jsCode);
        }
    }
    
    
    if (bridgeModel.jsCookie.length) {
        WKUserScript * cookieScript = [[WKUserScript alloc]initWithSource:bridgeModel.jsCookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [self.configuration.userContentController addUserScript:cookieScript];
        
        if (self.logEnable) {
            NSLog(@"✅ addJsCookie successed \n jsCookie == %@",bridgeModel.jsCookie);
        }
    }
    
    
    if (bridgeModel.handler) {
        for (NSString *handlerName in bridgeModel.handler.handlerNames) {
//            [self.configuration.userContentController addScriptMessageHandler:bridgeModel.handler.handler name:handlerName];
            
            [self.configuration.userContentController addScriptMessageHandler:self name:handlerName];
            
            if (self.logEnable) {
                NSLog(@"✅ addJsHandle successed \n handle == %@ & handleName == %@",NSStringFromClass([bridgeModel.handler.handler class]),handlerName);
            }
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.alpha = 1.0;
        
        float progress = [[change objectForKey:@"new"] floatValue];
        
        [self.progressView setProgress:progress animated:YES];
        if (progress >= 1.f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.f;
            } completion:^(BOOL finished) {
                self.progressView.progress = 0.f;
            }];
        }
    }
    
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:alertAction];
    [self.webViewController presentViewController:alertController animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.webViewController presentViewController:alertController animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(@"");
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textFiled = [alertController.textFields firstObject];
        if (textFiled) {
            completionHandler(textFiled.text);
        } else {
            completionHandler(@"");
        }
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        completionHandler(textField.text);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.webViewController presentViewController:alertController animated:YES completion:NULL];
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {

    
    if ([self.bridgeModel.handler.handlerNames containsObject:message.name]) {
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            
            if (self.logEnable) {
                NSLog(@"✅ js call oc method : %@ \n args : %@ \n callback : %@",[message.body objectForKey:@"methodName"],[message.body objectForKey:@"args"],[message.body objectForKey:@"callback"]);
            }
            NSArray *args = [message.body objectForKey:@"args"];
            Class targetClass = [self.bridgeModel.handler.handler class];
            SEL targetSelector = NSSelectorFromString([message.body objectForKey:@"methodName"]);
            NSMethodSignature *methodSignature = [targetClass instanceMethodSignatureForSelector:targetSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:targetSelector];
            [invocation setTarget:self.bridgeModel.handler.handler];
//            [invocation setArgument:&urlInfo atIndex:2];
//            [invocation setArgument:&completion atIndex:3];
            for (int i = 0; i < args.count; i ++) {
                id arg = args[i];
                [invocation setArgument:&arg atIndex:i + 2];
            }
            [invocation retainArguments];
            [invocation invoke];
            
            if ([message.body objectForKey:@"callback"]) {
                [self loadJavascriptCommand:[message.body objectForKey:@"callback"] completionHandler:nil];
            }
            
        }else {
            
            if (self.logEnable) {
                NSLog(@"❌ paramas is wrong, js call oc method : %@ ",message.name);
            }
            
        }

    }
    
    
    
}


@end
