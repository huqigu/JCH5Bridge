//
//  JCH5Bridge.h
//  JCH5Bridge_Example
//
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JCH5BridgeModel;
@interface JCH5Bridge : NSObject

@property (nonatomic,assign) BOOL logEnable;

@property (nonatomic,strong) WKWebView *webView;


/**
 创建JCH5Bridge实例对象

 @param logEnable 是否打印log
 @param bridgeModel 存储cookie、jscode、handle等需要注入到js的信息
 @return JCH5Bridge
 */
- (instancetype)initWithLogEnable:(BOOL)logEnable bridgeModel:(JCH5BridgeModel *)bridgeModel;


- (void)loadJavascriptCommand:(NSString *)javascriptCommand  completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))handler;

@end

NS_ASSUME_NONNULL_END
