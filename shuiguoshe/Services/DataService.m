//
//  DataService.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "DataService.h"

static NSString * const kAPIHost = @"http://shuiguoshe.com/api/v1";

@implementation DataService
{
    NSMutableDictionary* _cacheDict;
}

+ (DataService *)sharedService
{
    static DataService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !service ) {
            service = [[DataService alloc] init];
        }
    });
    return service;
}

- (DataService *)init
{
    if ( self = [super init] ) {
        _cacheDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// 不是真正的单例
// 如果调用init方法，那么需要调用release来处理内存
- (void)dealloc
{
    [_cacheDict release];
    [super dealloc];
}

- (NSString *)buildUrlFor:(NSString *)uri
{
    if ( !uri ) {
        return nil;
    }
    
    if ( [uri hasPrefix:@"/"] ) {
        uri = [uri substringFromIndex:1];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/%@", kAPIHost, uri];
#if DEBUG
    NSLog(@"url: %@", url);
#endif
    return url;
}

- (void)loadEntityForClass:(NSString *)clz
                       URI:(NSString *)uri
                completion:( void (^)(id result, BOOL succeed) )completion;
{
    NSString* url = [self buildUrlFor:uri];
    id responseObject = [_cacheDict objectForKey:url];
    if ( responseObject && completion ) {
        completion([self handleResponse:responseObject forClass:clz], YES);
        return;
    }
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             int code = [[responseObject objectForKey:@"code"] intValue];
             if ( code == 0 ) {
                 [_cacheDict setObject:responseObject forKey:url];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if ( completion ) {
                         completion([self handleResponse:responseObject forClass:clz], YES);
                     }
                 });
             } else {
                 if ( completion ) {
                     completion(nil, NO);
                 }
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Load Entity Error: %@", error);
             if ( completion ) {
                 completion(nil, NO);
             }
         }];
}

- (NSArray *)handleResponse:(id)responseObject forClass:(NSString *)clz
{
    NSArray* array = [responseObject objectForKey:@"data"];
    NSMutableArray* temp = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        id obj = [[NSClassFromString(clz) alloc] initWithDictionary:dict];
        [temp addObject:obj];
        [obj release];
    }
    return temp;
}

@end
