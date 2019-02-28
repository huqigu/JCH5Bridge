//
//  JCH5BridgeModel.m
//  JCH5Bridge_Example
//
//  Created by yellow on 2019/2/27.
//  Copyright © 2019 huqigu. All rights reserved.
//

#import "JCH5BridgeModel.h"

@interface JCH5BridgeModel ()

@end


@implementation JCH5BridgeModel


- (instancetype)initWithJsCode:(NSString *)jsCode jsCookieDict:(NSDictionary *)jsCookieDict handler:(nonnull JCH5BridgeHandler *)handler {
    
    if (self = [super init]) {
        _jsCode = jsCode;
        _jsCookie = @"";
        [jsCookieDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, NSString  *obj, BOOL * _Nonnull stop) {
            
            NSString *keyValue = [NSString stringWithFormat:@"%@=%@",key,obj];
            
            self->_jsCookie = [self->_jsCookie stringByAppendingString:[NSString stringWithFormat:@"document.cookie = '%@';",keyValue]];
            
        }];
        
        _handler = handler;
    }
    
    return self;
}

- (void)setJsCookie:(NSString *)jsCookie {
    
    _jsCookie = jsCookie;
    
    if (![jsCookie hasPrefix:@"document.cookie"]) {
        _jsCookie = [NSString stringWithFormat:@"document.cookie = '%@'",jsCookie];
    }
}

@end
