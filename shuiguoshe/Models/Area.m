//
//  Area.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Area.h"

@implementation Area

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.name = [jsonObj objectForKey:@"name"];
        self.address = [jsonObj objectForKey:@"address"];
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.address = nil;
    [super dealloc];
}

@end
