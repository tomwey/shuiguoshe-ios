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

- (void)startRequest
{
    UIView* view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)finishRequest
{
    UIView* view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (NSString *)buildUrlFor:(NSString *)uri
{
    if ( !uri ) {
        return nil;
    }
    
    if ( [uri hasPrefix:@"/"] ) {
        uri = [uri substringFromIndex:1];
    }
    
    NSString* apiHost = kAPIHost;

    NSString* url = [NSString stringWithFormat:@"%@/%@", apiHost, uri];
#if DEBUG
    NSLog(@"url: %@", url);
#endif
    return url;
}

- (void)post:(NSString *)uri
      params:(NSDictionary *)params
  completion:( void (^)(id result, BOOL succeed) )completion
{
    NSString* url = [self buildUrlFor:uri];
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                if ( [[responseObject objectForKey:@"code"] intValue] == 0 ) {
                    completion(responseObject, YES);
                } else {
                    completion(@{ @"code": [responseObject objectForKey:@"code"], @"message": [responseObject objectForKey:@"message"] }, NO);
                }
                
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                completion(@{ @"code": @(error.code), @"message": error.domain }, NO);
            }
        });
    }];
}

- (void)delete:(NSString *)uri
      params:(NSDictionary *)params
  completion:( void (^)(id result, BOOL succeed) )completion
{
    NSString* url = [self buildUrlFor:uri];
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                if ( [[responseObject objectForKey:@"code"] intValue] == 0 ) {
                    completion(responseObject, YES);
                } else {
                    completion(@{ @"code": [responseObject objectForKey:@"code"], @"message": [responseObject objectForKey:@"message"] }, NO);
                }
                
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                completion(@{ @"code": @(error.code), @"message": error.domain }, NO);
            }
        });
    }];
}

- (void)loadEntityForClass:(NSString *)clz
                       URI:(NSString *)uri
                completion:( void (^)(id result, BOOL succeed) )completion;
{
    NSString* url = [self buildUrlFor:uri];
//    id responseObject = [_cacheDict objectForKey:url];
//    if ( responseObject && completion ) {
//        completion([self handleResponse:responseObject forClass:clz], YES);
//        return;
//    }
    
//    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
//                 [self finishRequest];
             
                 int code = [[responseObject objectForKey:@"code"] intValue];
                 
                 if ( code == 0 ) {
                     [_cacheDict setObject:responseObject forKey:url];
                     
                     if ( completion ) {
                         completion([self handleResponse:responseObject forClass:clz], YES);
                     }
                 } else {
                     if ( completion ) {
                         completion(nil, NO);
                     }
                 }
            });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Load Entity Error: %@", error);
//             [self finishRequest];
             if ( completion ) {
                 completion(nil, NO);
             }
         }];
}

- (void)uploadImage:(UIImage *)anImage URI:(NSString *)uri params:(NSDictionary *)params completion:( void (^)(id result, BOOL succeed) )completion
{
    NSData* imageData = UIImageJPEGRepresentation(anImage, 0.5);
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@", kAPIHost, uri]
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"upload success");
              [self finishRequest];
              if ( completion ) {
                  completion(nil, YES);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"upload error");
              [self finishRequest];
              if ( completion ) {
                  completion(nil, NO);
              }
          }];
}

- (id)handleResponse:(id)responseObject forClass:(NSString *)clz
{
    id result = [responseObject objectForKey:@"data"];
    if ( [result isKindOfClass:[NSArray class]] ) {
        NSMutableArray* temp = [NSMutableArray array];
        for (NSDictionary* dict in result) {
            id obj = [[NSClassFromString(clz) alloc] initWithDictionary:dict];
            [temp addObject:obj];
            [obj release];
        }
        return temp;
    } else if ( [result isKindOfClass:[NSDictionary class]] ) {
        return [[[NSClassFromString(clz) alloc] initWithDictionary:result] autorelease];
    }
    
    return nil;
}

@end
