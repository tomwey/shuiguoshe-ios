//
//  ShipmentInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ShipmentInfo.h"

@implementation ShipmentInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.name = [jsonObj objectForKey:@"name"];
        self.prefix = [jsonObj objectForKey:@"prefix"];
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.prefix = nil;
    [super dealloc];
}

@end
