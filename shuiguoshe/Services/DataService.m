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

- (Area *)areaForLocal
{
    id val = [[NSUserDefaults standardUserDefaults] objectForKey:@"select.area"];
    if ( !val ) {
        return nil;
    }
    
    NSArray* values = [val componentsSeparatedByString:@";"];
    
    Area* a = [[[Area alloc] init] autorelease];
    a.oid = [values[0] integerValue];
    a.name = values[1];
    
    return a;
}

- (void)saveAreaToLocal:(Area *)area
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d;%@", area.oid, area.name]
                                              forKey:@"select.area"];
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
  completion:( void (^)(NetworkResponse* resp) )completion
{
    NSString* url = [self buildUrlFor:uri];
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
#if DEBUG
        NSLog(@"uri: %@, resp: %@", uri, responseObject);
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                NSString* msg = [responseObject objectForKey:@"message"];
                
                NetworkResponse* resp = [NetworkResponse responseWithStatusCode:code
                                                                        message:msg
                                                                         result:[responseObject objectForKey:@"data"]];
                resp.requestSuccess = YES;
                
                completion(resp);
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
        NSLog(@"post error: %@", error);
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishRequest];
            if ( completion ) {
                NSInteger code = error.code;
                NSString* msg = error.localizedDescription;
                NetworkResponse* resp = [NetworkResponse responseWithStatusCode:code
                                                                        message:msg
                                                                         result:nil];
                resp.requestSuccess = NO;
                
                completion(resp);
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
    
    [self startRequest];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self finishRequest];
             
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
             [self finishRequest];
             if ( completion ) {
                 NSDictionary* result = @{ @"code": @"500", @"message": @"请求失败" };
                 completion(result, NO);
             }
         }];
}

- (void)uploadImage:(UIImage *)anImage URI:(NSString *)uri params:(NSDictionary *)params completion:(void (^)(NetworkResponse *))completion
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
//              NSLog(@"upload success");
              [self finishRequest];
              
              NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
              NSString* msg = [responseObject objectForKey:@"message"];
              
              NetworkResponse* resp = [NetworkResponse responseWithStatusCode:code
                                                                      message:msg
                                                                       result:nil];
              
              resp.requestSuccess = YES;
              
              if ( completion ) {
                  completion(resp);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"upload error");
              [self finishRequest];
              
              NSInteger code = error.code;
              NSString* msg = error.localizedDescription;
              
              NetworkResponse* resp = [NetworkResponse responseWithStatusCode:code
                                                                      message:msg
                                                                       result:nil];
              
              resp.requestSuccess = NO;
              
              if ( completion ) {
                  completion(resp);
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

@implementation NetworkResponse

+ (NetworkResponse *)responseWithStatusCode:(NSInteger)code
                                    message:(NSString *)message
                                     result:(id)result
{
    NetworkResponse* resp = [[[NetworkResponse alloc] init] autorelease];
    resp.statusCode = code;
    resp.message = message;
    resp.result = result;
    return resp;
}

- (void)dealloc
{
    self.message = nil;
    self.result = nil;
    
    [super dealloc];
}

@end
