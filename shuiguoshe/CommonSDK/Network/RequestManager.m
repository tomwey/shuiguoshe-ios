//
//  RequestManager.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "RequestManager.h"
#import "Defines.h"

static NSString * const kNetworkNotReachable = @"网络连接失败";
static NSString * const kServerError = @"呃，系统出错了";

@implementation RequestManager
{
    NSMutableDictionary* _firstLoadStatus;
}

+ (RequestManager*)sharedInstance
{
    static RequestManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[RequestManager alloc] init];
        }
    });
    
    return instance;
}

- (id)init
{
    if ( self = [super init] ) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeActive) name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        // 检测网络连接的单例,网络变化时的回调方法
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [self didBecomeActive];
        }];
        
        [AFNetworkReachabilityManager sharedManager];
    }
    return self;
}

- (void)didBecomeActive
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    
    if ( status == AFNetworkReachabilityStatusNotReachable ) {
        [Toast showText:kNetworkNotReachable];
    } else {
        [self checkNetwork];
    }
}

// GET请求
// 请求参数会拼接到地址的后面，形如：http://www.xxx.com?key=value&key2=value2
- (void)GET:(NSString*)url params:(NSDictionary*)params result:( void (^)(RequestResult *rr) )resultBlock
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 RequestResult* result = [self handleResponseResult:responseObject];
                 
                 if ( resultBlock ) {
                     resultBlock(result);
                 }
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             DLog(@"GET Error: %@", error);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 if ( [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable ) {
                     [Toast showText:kNetworkNotReachable];
                 } else {
                     [self checkNetwork];
                 }
                 
                 if ( resultBlock ) {
                     resultBlock(nil);
                 }
             });
         }];
}

// POST请求
- (void)POST:(NSString*)url params:(NSDictionary*)params result:(void (^)(RequestResult *))result
{
    
}

- (RequestResult *)handleResponseResult:(id)response
{
    NSInteger code = [[response objectForKey:@"code"] integerValue];
    NSString* message = [response objectForKey:@"message"];
    id data = [response objectForKey:@"data"];
    RequestResult* rr = [RequestResult resultWithStatusCode:code
                                                    message:message
                                                       data:data];
    return rr;
}

- (void)checkNetwork
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:
                                              [NSURL URLWithString:@"http://www.baidu.com"]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ( connectionError ) {
                                   [Toast showText:kNetworkNotReachable];
                               } else {
                                   [Toast showText:kServerError];
                               }
                           }];
    
}

@end

@implementation RequestResult

- (void)dealloc
{
    self.message = nil;
    self.data = nil;
    [super dealloc];
}

+ (RequestResult *)resultWithStatusCode:(NSInteger)statusCode message:(NSString *)message data:(id)data
{
    RequestResult* rr = [[[RequestResult alloc] init] autorelease];
    rr.statusCode = statusCode;
    rr.message = message;
    rr.data = data;
    return rr;
}

@end