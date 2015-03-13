//
//  RequestManager.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

// 本库基于AFNetworking框架

@class RequestResult;

@interface RequestManager : NSObject

+ (RequestManager*)sharedInstance;

// GET请求
// 请求参数会拼接到地址的后面，形如：http://www.xxx.com?key=value&key2=value2
- (void)GET:(NSString*)url params:(NSDictionary*)params result:( void (^)(RequestResult*) )result;

// POST请求
- (void)POST:(NSString*)url params:(NSDictionary*)params result:( void (^)(RequestResult*) )result;

@end

@interface RequestResult : NSObject

// API返回的自定义错误码以及服务器发生错误的状态码
@property (nonatomic, assign) NSInteger statusCode;

// API返回的消息，以及服务器发生错误的消息
@property (nonatomic, copy) NSString* message;

// API返回的结果，可能是数组，也可能是映射好的对象
// 需要注意：如果发生服务器错误，那么值为nil
@property (nonatomic, retain) id data;

+ (RequestResult *)resultWithStatusCode:(NSInteger)statusCode message: (NSString *)message data: (id)data;

@end
