//
//  OrderCollection.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderCollection.h"
#import "Defines.h"

@implementation OrderCollection

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.totalPage = [[jsonObj objectForKey:@"total_pages"] integerValue];
        self.totalRecord = [[jsonObj objectForKey:@"total_records"] integerValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        for (id val in [jsonObj objectForKey:@"items"]) {
            OrderInfo* oi = [[OrderInfo alloc] initWithDictionary:val];
            [temp addObject:oi];
            [oi release];
        }
        
        self.orders = temp;
    }
    return self;
}

- (void)dealloc
{
    self.orders = nil;
    [super dealloc];
}

@end
