//
//  JCH5BridgeModel.h
//  JCH5Bridge_Example
//
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JCH5BridgeHandler;
NS_ASSUME_NONNULL_BEGIN

@interface JCH5BridgeModel : NSObject

@property (nonatomic,copy) NSString *jsCode;

@property (nonatomic,copy) NSString *jsCookie;

@property (nonatomic,strong) JCH5BridgeHandler *handler;


/**
 JCH5BridgeModel

 @param jsCode 注入的js代码
 @param jsCookieDict 注入的cookie字典
 @param handler js调用oc方法的接收对象model
 @return JCH5BridgeModel
 */
- (instancetype)initWithJsCode:(NSString *)jsCode jsCookieDict:(NSDictionary *)jsCookieDict handler:(JCH5BridgeHandler *)handler;

@end

NS_ASSUME_NONNULL_END
