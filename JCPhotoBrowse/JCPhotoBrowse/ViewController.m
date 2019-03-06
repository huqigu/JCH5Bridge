//
//  ViewController.m
//  JCPhotoBrowse
//
//  Created by yellow on 2019/3/4.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "ViewController.h"
#import <JCH5Bridge.h>
#import "YBImageBrowser.h"

@interface ViewController ()<YBImageBrowserDataSource>

@property (nonatomic,strong) JCH5Bridge *bridge;

@property (nonatomic,strong) NSMutableArray *images;

@property (nonatomic,strong) YBImageBrowser *browser;

@end

@implementation ViewController

#pragma mark - Setter & Getter

- (NSMutableArray *)images {
    
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *jsCode = @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i = 0;i < objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    window.webkit.messageHandlers.methodName1.postMessage({methodName:\"receiveImages:\", args:[imgScr],callback:\"registerImageClickAction()\"})\
    };function registerImageClickAction(){\
    var imgs = document.getElementsByTagName('img');\
    var length = imgs.length;\
    for(var i = 0;i < length;i++){\
    img = imgs[i];\
    img.onclick = function(){\
    window.webkit.messageHandlers.methodName2.postMessage({methodName:\"clickImage:\", args:[this.src],callback:\"\"})\
    }\
    }\
    }";
    
    JCH5BridgeHandler *handler = [[JCH5BridgeHandler alloc] initWithHandler:self handlerNames:@[@"methodName1",@"methodName2"]];
    
    JCH5BridgeModel *model = [[JCH5BridgeModel alloc] initWithJsCode:jsCode jsCookieDict:@{} handler:handler];
    
    self.bridge = [[JCH5Bridge alloc] initWithLogEnable:YES progressEnable:YES bridgeModel:model];
    
    self.bridge.webViewController = self;
    
    [self.bridge loadUrl:[NSURL URLWithString:@"https://baijiahao.baidu.com/s?id=1572864490439646&wfr=spider&for=pc"] completionHandler:^{
        [self.bridge loadJavascriptCommand:@"getImages()" completionHandler:nil];
    }];
    
    
    
}

#pragma mark - JS Call OC

- (void)receiveImages:(NSString *)images {
    
//    NSLog(@"images == %@",images);
    
    [self.images removeAllObjects];
    
    [self.images addObjectsFromArray:[images componentsSeparatedByString:@"+"]];
    
    
}

- (void)clickImage:(NSString *)imageSrc {
    
//    NSLog(@"imageSrc == %@",imageSrc);
    
    self.browser = [YBImageBrowser new];
    self.browser.dataSource = self;
    [self.browser reloadData];
    for (int i = 0; i < self.images.count; i++) {
        if ([imageSrc isEqualToString:self.images[i]]) {
            self.browser.currentIndex = i;
             break;
        }
    }
    
    [self.browser show];
}

#pragma mark - YBImageBrowserDataSource
// 实现 <YBImageBrowserDataSource> 协议方法配置数据源
- (NSUInteger)yb_numberOfCellForImageBrowserView:(YBImageBrowserView *)imageBrowserView {
    return self.images.count;
}
- (id<YBImageBrowserCellDataProtocol>)yb_imageBrowserView:(YBImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index {
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = self.images[index];
//    data.sourceObject = ...;
    return data;
}


@end
