//
//  DataService.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "DataService.h"

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

- (void)loadEntityForClass:(NSString *)clz
                       URL:(NSString *)url
                completion:( void (^)(id result, BOOL succeed) )completion;
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             int code = [[responseObject objectForKey:@"code"] intValue];
             if ( code == 0 ) {
                 if ( completion ) {
                     NSArray* array = [responseObject objectForKey:@"data"];
                     NSMutableArray* temp = [NSMutableArray array];
                     for (NSDictionary* dict in array) {
                         id obj = [[NSClassFromString(clz) alloc] initWithDictionary:dict];
                         [temp addObject:obj];
                         [obj release];
                     }
                     completion(temp, YES);
                 }
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

@end
