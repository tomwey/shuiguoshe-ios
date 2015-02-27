//
//  NewOrderInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-27.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NewOrderInfo.h"
#import "Defines.h"

@implementation NewOrderInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.userScore = [[[jsonObj objectForKey:@"user"] objectForKey:@"score"] integerValue];
        
        self.deliverInfo = [[[DeliverInfo alloc] initWithDictionary:[[jsonObj objectForKey:@"user"] objectForKey:@"deliver_info"]] autorelease];
        self.totalPrice = [[[jsonObj objectForKey:@"cart"] objectForKey:@"total_price"] floatValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        for (id val in [[jsonObj objectForKey:@"cart"] objectForKey:@"items"]) {
            LineItem* item = [[LineItem alloc] initWithDictionary:val];
            [temp addObject:item];
            [item release];
        }
        self.items = temp;
        
        NSLog(@"score:%d", self.userScore);
    }
    
    return self;
}

- (void)dealloc
{
    self.deliverInfo = nil;
    self.items = nil;
    [super dealloc];
}

@end
