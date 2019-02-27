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

@property (nonatomic,strong) NSArray<JCH5BridgeHandler *>* handlers;

- (instancetype)initWithJsCode:(NSString *)jsCode jsCookieDict:(NSDictionary *)jsCookieDict handlers:(NSArray<JCH5BridgeHandler *> *)handlers;

@end

NS_ASSUME_NONNULL_END
