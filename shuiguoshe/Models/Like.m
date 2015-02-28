//
//  Like.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Like.h"

@implementation Like

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.itemId = [[jsonObj objectForKey:@"item_id"] integerValue];
        self.itemIconUrl = [jsonObj objectForKey:@"item_icon_url"];
        self.itemTitle = [jsonObj objectForKey:@"item_title"];
        self.itemPrice = [[jsonObj objectForKey:@"item_price"] floatValue];
    }
    return self;
}

- (void)dealloc
{
    self.itemIconUrl = nil;
    self.itemTitle = nil;
    
    [super dealloc];
}

@end
