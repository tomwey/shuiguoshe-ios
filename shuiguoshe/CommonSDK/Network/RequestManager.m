//
//  RequestManager.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"

@implementation RequestManager

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

// GET请求
// 请求参数会拼接到地址的后面，形如：http://www.xxx.com?key=value&key2=value2
- (void)GET:(NSString*)url params:(NSDictionary*)params result:(void (^)(RequestResult *))result
{
    
}

// POST请求
- (void)POST:(NSString*)url params:(NSDictionary*)params result:(void (^)(RequestResult *))result
{
    
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