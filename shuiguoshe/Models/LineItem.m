//
//  LineItem.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "LineItem.h"

@implementation LineItem

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.objectId = [[jsonObj objectForKey:@"id"] integerValue];
        
        self.itemId = [[jsonObj objectForKey:@"pid"] integerValue];
        
        self.itemTitle = [jsonObj objectForKey:@"title"];
        self.itemIconUrl = [jsonObj objectForKey:@"icon_url"];
        
        self.quantity = [[jsonObj objectForKey:@"quantity"] floatValue];
        
        self.price = [[jsonObj objectForKey:@"price"] floatValue];
        self.totalPrice = [[jsonObj objectForKey:@"total_price"] floatValue];
    }
    return self;
}

- (void)dealloc
{
    self.itemTitle = nil;
    self.itemIconUrl = nil;
    [super dealloc];
}

@end
