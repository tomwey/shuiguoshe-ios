//
//  Sale.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Sale.h"

@implementation Sale

- (Sale *)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.sid           = [[jsonObj objectForKey:@"id"] integerValue];
        
        self.title         = [jsonObj objectForKey:@"title"];
        self.subtitle      = [jsonObj objectForKey:@"subtitle"];
        
        self.closedAt      = [jsonObj objectForKey:@"closed_at"];
        
        self.logoUrl       = [jsonObj objectForKey:@"logo_url"];
        self.coverImageUrl = [jsonObj objectForKey:@"cover_image_url"];
    }
    return self;
}

- (void)dealloc
{
    self.title         = nil;
    self.subtitle      = nil;
    
    self.closedAt      = nil;
    
    self.logoUrl       = nil;
    self.coverImageUrl = nil;
    [super dealloc];
}

@end
