//
//  ItemDetail.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ItemDetail.h"

@implementation ItemDetail

- (id)initWithDictionary:(NSDictionary *)jsonResult
{
    if ( self = [super init] ) {
        self.itemId = [[jsonResult objectForKey:@"id"] integerValue];
        
        self.title = [jsonResult objectForKey:@"title"];
        self.lowPrice = [[jsonResult objectForKey:@"low_price"] floatValue];
        self.originPrice = [[jsonResult objectForKey:@"origin_price"] floatValue];
        self.ordersCount = [[jsonResult objectForKey:@"orders_count"] integerValue];
        self.unit = [jsonResult objectForKey:@"units"];
        
        self.discountScore = [[jsonResult objectForKey:@"discount_score"] integerValue];
        
        self.largeImage = [jsonResult objectForKey:@"large_image"];
        self.note = [jsonResult objectForKey:@"note"];
        self.deliverInfo = [jsonResult objectForKey:@"deliver_info"];
        
        self.likesCount = [[jsonResult objectForKey:@"likes_count"] integerValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        NSArray* photos = [jsonResult objectForKey:@"intro_images"];
        for (id item in photos) {
            Photo* p = [[[Photo alloc] initWithDictionary:item] autorelease];
            [temp addObject:p];
        }
        
        self.photos = [NSArray arrayWithArray:temp];
    }
    
    return self;
}

- (CGFloat)totalHeightForImages
{
    CGFloat height = 0;
    for (Photo* p in self.photos) {
        height += p.scaledImageHeight;
    }
    return height;
}

- (NSString *)lowPriceText
{
    return [NSString stringWithFormat:@"￥%.2f", self.lowPrice];
}

- (NSString *)originPriceText
{
    return [NSString stringWithFormat:@"￥%.2f", self.originPrice];
}

- (void)dealloc
{
    self.title = nil;
    self.unit = nil;
    self.largeImage = nil;
    self.note = nil;
    self.deliverInfo = nil;
    self.photos = nil;
    
    [super dealloc];
}

@end
