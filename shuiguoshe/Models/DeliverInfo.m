//
//  DeliverInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-27.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "DeliverInfo.h"

@implementation DeliverInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.infoId = [[jsonObj objectForKey:@"id"] integerValue];
        
        self.mobile = [jsonObj objectForKey:@"mobile"];
        
        self.address = [jsonObj objectForKey:@"address"];
    }
    
    return self;
}

- (void)dealloc
{
    self.mobile = nil;
    self.address = nil;
    
    [super dealloc];
}

@end
