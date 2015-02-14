//
//  Cart.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Cart.h"
#import "Defines.h"

@implementation Cart

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.totalPrice = [[jsonObj objectForKey:@"total_price"] floatValue];
        self.totalQuantity = [[jsonObj objectForKey:@"total"] integerValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        for ( id dict in [jsonObj objectForKey:@"items"]) {
            LineItem* item = [[[LineItem alloc] initWithDictionary:dict] autorelease];
            [temp addObject:item];
        }
        
        self.items = temp;
    }
    return self;
}

- (void)dealloc
{
    self.items = nil;
    [super dealloc];
}

@end
