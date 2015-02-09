//
//  Catalog.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Catalog.h"

@implementation Catalog

- (Catalog *)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.cid = [[jsonObj objectForKey:@"id"] integerValue];
        self.name = [jsonObj objectForKey:@"name"];
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    [super dealloc];
}

@end
