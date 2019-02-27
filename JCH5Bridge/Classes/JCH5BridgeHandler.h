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

@property (nonatomic,assign) id<WKScriptMessageHandler> handler;

@property (nonatomic,copy) NSString *handlerName;

- (instancetype)initWithHandler:(id<WKScriptMessageHandler>)handler handlerName:(NSString *)handleName;

@end

NS_ASSUME_NONNULL_END
