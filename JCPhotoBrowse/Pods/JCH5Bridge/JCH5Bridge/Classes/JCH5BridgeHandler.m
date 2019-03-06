//
//  JCH5BridgeHandler.m
//  JCH5Bridge_Example
//
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import "JCH5BridgeHandler.h"

@implementation JCH5BridgeHandler

- (instancetype)initWithHandler:(id)handler handlerNames:(NSArray<NSString *> *)handleNames {
    
    if (self = [super init]) {
        
        _handler = handler;
        _handlerNames = handleNames;
    }
    
    return self;
}

@end
