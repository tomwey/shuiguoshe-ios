//
//  ScoreTrace.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreTrace : NSObject

@property (nonatomic, assign) NSInteger oid;

@property (nonatomic, copy) NSString* operType;

@property (nonatomic, copy) NSString* summary;

@property (nonatomic, copy) NSString* createdAt;

@property (nonatomic, assign) NSInteger score;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
