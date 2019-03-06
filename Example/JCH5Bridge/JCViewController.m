//
//  JCViewController.m
//  JCH5Bridge
//
//  Created by huqigu on 02/27/2019.
//  Copyright (c) 2019 huqigu. All rights reserved.
//

#import "JCViewController.h"
#import "JCH5Bridge.h"
#import <WebKit/WebKit.h>
@interface JCViewController ()

@property (nonatomic,strong) JCH5Bridge *bridge;

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
    window.webkit.messageHandlers.methodName1.postMessage({methodName:\"sayHelloWithName:message:\", args:[\"Tom\",\"hello world\"],callback:\"readCookie()\"});\
    window.webkit.messageHandlers.methodName2.postMessage(\"this is message2\");\
    };";
    
    
    JCH5BridgeHandler *handler = [[JCH5BridgeHandler alloc] initWithHandler:self handlerNames:@[@"methodName1",@"methodName2"]];
    
    
    JCH5BridgeModel *model = [[JCH5BridgeModel alloc] initWithJsCode:jsCode jsCookieDict:@{@"username":@"jc",@"password":@"123"} handler:handler];
    
    
    self.bridge = [[JCH5Bridge alloc] initWithLogEnable:YES progressEnable:YES bridgeModel:model];
    self.bridge.webViewController = self;
    
   
    [self.bridge loadUrl:[[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"] completionHandler:^{
        [self.bridge loadJavascriptCommand:@"readCookie()" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            
            [self.bridge loadJavascriptCommand:@"jsCallOc()" completionHandler:nil];
            
        }];
    }];
//    [self.bridge loadUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    
}



// JS最终调用的OC方法
- (void)sayHelloWithName:(NSString *)name message:(NSString *)message {
    
    NSLog(@"name == %@ && message == %@",name,message);
    
}

@end
