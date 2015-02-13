//
//  DataService.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@interface DataService : NSObject

+ (DataService *)sharedService;

- (void)loadEntityForClass:(NSString *)clz
                       URI:(NSString *)uri
                completion:( void (^)(id result, BOOL succeed) )completion;

- (void)post:(NSString *)uri
      params:(NSDictionary *)params
  completion:( void (^)(id result, BOOL succeed) )completion;

- (void)delete:(NSString *)uri
        params:(NSDictionary *)params
    completion:( void (^)(id result, BOOL succeed) )completion;

- (void)uploadImage:(UIImage *)anImage
                URI:(NSString *)uri
             params:(NSDictionary *)params
         completion:( void (^)(id result, BOOL succeed) )completion;

@end
