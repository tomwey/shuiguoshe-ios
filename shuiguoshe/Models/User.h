//
//  User.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) NSInteger oid;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* password;

@property (nonatomic, copy) NSString* code;
@property (nonatomic, copy) NSString* codeType;

@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, copy) NSString* avatarUrl;

@property (nonatomic, assign) NSUInteger deliveringCount;
@property (nonatomic, assign) NSUInteger completedCount;
@property (nonatomic, assign) NSUInteger canceledCount;

@property (nonatomic, assign) NSInteger currentDeliverInfoId;


- (id)initWithDictionary:(NSDictionary *)jsonObj;

- (NSArray *)errors;

- (BOOL)checkValue;
- (BOOL)checkMobile;

@end
