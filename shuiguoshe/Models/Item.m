//
//  Item.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Item.h"

@implementation Item

- (Item*)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.iid           = [[jsonObj objectForKey:@"id"] integerValue];
        
        self.title         = [jsonObj objectForKey:@"title"];
        self.subtitle      = [jsonObj objectForKey:@"subtitle"];
        
        self.intro         = [jsonObj objectForKey:@"intro"];
        
        self.thumbImageUrl = [jsonObj objectForKey:@"thumb_image"];
        
        self.lowPrice      = [jsonObj objectForKey:@"low_price"];
        self.originPrice   = [jsonObj objectForKey:@"origin_price"];
        
        self.unit          = [jsonObj objectForKey:@"unit"];
        self.ordersCount   = [[jsonObj objectForKey:@"orders_count"] integerValue];
        self.discountScore = [[jsonObj objectForKey:@"discount_score"] integerValue];
        self.discountedAt  = [jsonObj objectForKey:@"discounted_at"];
        
        self.likesCount   = [[jsonObj objectForKey:@"likes_count"] integerValue];
    }
    
    return self;
}

- (void)dealloc
{
    self.title         = nil;
    self.subtitle      = nil;
    
    self.intro         = nil;
    
    self.thumbImageUrl = nil;
    
    self.lowPrice      = nil;
    self.originPrice   = nil;
    
    self.unit          = nil;
    self.discountedAt  = nil;
    
    [super dealloc];
}

- (BOOL)liked
{
    return self.likesCount > 0;
}

- (NSString *)lowPriceText
{
    return [NSString stringWithFormat:@"￥%@", self.lowPrice];
}

- (NSString *)originPriceText
{
    return [NSString stringWithFormat:@"￥%@", self.originPrice];
}

@end
