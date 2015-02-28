//
//  OrderInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderInfo.h"
#import "LineItem.h"

@implementation OrderInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.no = [jsonObj objectForKey:@"order_no"];
        self.state = [jsonObj objectForKey:@"state"];
        self.orderedAt = [jsonObj objectForKey:@"ordered_at"];
        self.deliveredAt = [jsonObj objectForKey:@"delivered_at"];
        
        self.totalPrice = [[jsonObj objectForKey:@"total_price"] floatValue];
        
        self.canCancel = [[jsonObj objectForKey:@"can_cancel"] boolValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        for (id val in [jsonObj objectForKey:@"items"]) {
            LineItem* item = [[LineItem alloc] initWithDictionary:val];
            [temp addObject:item];
            [item release];
        }
        self.items = temp;
    }
    return self;
}

- (void)dealloc
{
    self.no = nil;
    self.state = nil;
    self.orderedAt = nil;
    self.deliveredAt = nil;
    self.items = nil;
    
    [super dealloc];
}

@end
