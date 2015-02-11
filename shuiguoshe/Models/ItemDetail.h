//
//  ItemDetail.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface ItemDetail : NSObject

@property (nonatomic, copy) NSString* largeImage;
@property (nonatomic, copy) NSString* note;
@property (nonatomic, copy) NSString* deliverInfo;
@property (nonatomic, copy) NSArray* photos;

- (id)initWithDictionary:(NSDictionary *)jsonResult;

- (CGFloat)totalHeightForImages;

@end
