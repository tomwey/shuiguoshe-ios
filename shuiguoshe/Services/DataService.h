//
//  DataService.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@class NetworkResponse;
@interface DataService : NSObject

+ (DataService *)sharedService;

- (void)loadEntityForClass:(NSString *)clz
                       URI:(NSString *)uri
                completion:( void (^)(id result, BOOL succeed) )completion;

- (void)post:(NSString *)uri
      params:(NSDictionary *)params
  completion:( void (^)(NetworkResponse *) )completion;

- (void)uploadImage:(UIImage *)anImage
                URI:(NSString *)uri
             params:(NSDictionary *)params
         completion:( void (^)(NetworkResponse* resp) )completion;

- (Area *)areaForLocal;
- (void)saveAreaToLocal:(Area *)area;

@end

typedef NS_ENUM(NSInteger, NetworkResponseResultType) {
    NetworkResponseResultTypeSuccess = 0,
    NetworkResponseResultTypeServerError = -1,
    NetworkResponseResultTypeNoRecords = 1,
};

@interface NetworkResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, retain) id result;

@property (nonatomic, assign) BOOL requestSuccess;

+ (NetworkResponse *)responseWithStatusCode:(NSInteger)code
                                    message:(NSString *)message
                                     result:(id)result;

@end
