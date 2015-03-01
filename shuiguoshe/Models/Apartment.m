//
//  Apartment.m
//  shuiguoshe
//
//  Created by tomwey on 3/1/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import "Apartment.h"

@implementation Apartment


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
