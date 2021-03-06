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
    BOOL _loading;
    NSMutableDictionary* _firstLoadStates;
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
        _loading = NO;
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
    if ( values.count > 2 ) {
        a.address = values[2];
    }
    
    return a;
}

- (void)saveAreaToLocal:(Area *)area
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d;%@;%@", area.oid, area.name, area.address]
                                              forKey:@"select.area"];
}

- (void)startRequest
{
    _loading = YES;
    
    UIView* view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

- (void)finishRequest
{
    _loading = NO;
    
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
    
    DLog(@"请求URL: %@", url);
    
    return url;
}

- (void)post:(NSString *)uri
      params:(NSDictionary *)params
  completion:( void (^)(NetworkResponse* resp) )completion
{
    if ( _loading ) {
        return;
    }
    
    NSString* url = [self buildUrlFor:uri];
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"成功返回: %@", responseObject);
        
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

        DLog(@"请求错误: %@", error);
        
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
                completion:( void (^)(id result, BOOL succeed) )completion
               showLoading:(BOOL)yesOrNo
{
    if ( _loading ) {
        return;
    }
    
    _loading = YES;
    
    NSString* url = [self buildUrlFor:uri];
    
    if ( yesOrNo ) {
        UIView* view = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    [[RequestManager sharedInstance] GET:url
                                  params:nil
                                  result:^(RequestResult *result) {
                                      
                                      [self finishRequest];
                                      
                                      if ( result ) {
                                          if ( result.statusCode == 0 ) {
                                              if ( completion ) {
                                                  completion([self handleResponse:result.data forClass:clz], YES);
                                              }
                                              
                                              if ( !_firstLoadStates ) {
                                                  _firstLoadStates = [[NSMutableDictionary alloc] init];
                                              }
                                              
                                              [_firstLoadStates setObject:@(YES) forKey:uri];
                                              
                                          } else {
                                              if ( completion ) {
                                                  completion(nil, YES);
                                              }
                                          }
                                      } else {
                                          // 请求出错
                                          
                                          if ( completion ) {
                                              completion(nil, NO);
                                          }
                                      }
                                      
                                  }];
    
    /*
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
             DLog(@"Load Entity Error: %@", error);
             [self finishRequest];
             
             AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
             
             if ( status == AFNetworkReachabilityStatusNotReachable ) {
                 [Toast showText:@"无网络连接，请检查设置"];
             } else {
                 [Toast showText:@"呃，系统出错了"];
             }
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoadEntityErrorNotification"
//                                                                 object:uri];
             
             if ( completion ) {
                 completion(nil, NO);
             }
         }];*/
}

- (BOOL)canShowErrorViewForURI:(NSString *)uri
{
    return ![[_firstLoadStates objectForKey:uri] boolValue];
}

- (void)loadEntityForClass:(NSString *)clz
                       URI:(NSString *)uri
                completion:( void (^)(id result, BOOL succeed) )completion;
{
    [self loadEntityForClass:clz
                         URI:uri
                  completion:completion
                 showLoading:YES];
}

- (void)uploadImage:(UIImage *)anImage URI:(NSString *)uri params:(NSDictionary *)params completion:(void (^)(NetworkResponse *))completion
{
    if ( _loading ) {
        return;
    }
    
    NSData* imageData = UIImageJPEGRepresentation(anImage, 0.5);
    
    [self startRequest];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@", kAPIHost, uri]
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    
}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    id result = responseObject;//[responseObject objectForKey:@"data"];
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
