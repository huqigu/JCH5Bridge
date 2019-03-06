//
//  JCH5BridgeHandler.h
//  JCH5Bridge_Example
//
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCH5BridgeHandler : NSObject

@property (nonatomic,assign) id handler;

@property (nonatomic,copy) NSArray<NSString *> *handlerNames;


/**
 JCH5BridgeHandler

 @param handler js调用oc方法的接收对象
 @param handleNames js调用的所有oc方法
 @return JCH5BridgeHandler
 */
- (instancetype)initWithHandler:(id)handler handlerNames:(NSArray<NSString *> *)handleNames;

@end

NS_ASSUME_NONNULL_END
