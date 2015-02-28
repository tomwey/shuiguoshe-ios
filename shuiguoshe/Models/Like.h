//
//  Like.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Like : NSObject

@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString* itemTitle;
@property (nonatomic, copy) NSString* itemIconUrl;
@property (nonatomic, assign) float itemPrice;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
