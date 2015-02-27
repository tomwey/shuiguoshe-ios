//
//  DeliverInfo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-27.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliverInfo : NSObject

@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* address;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
