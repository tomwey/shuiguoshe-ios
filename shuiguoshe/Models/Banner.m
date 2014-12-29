//
//  Banner.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "Banner.h"

@implementation Banner

- (Banner *)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.bid = [[jsonObj objectForKey:@"id"] integerValue];
        
        self.title = [jsonObj objectForKey:@"title"];
        self.subtitle = [jsonObj objectForKey:@"subtitle"];
        self.intro = [jsonObj objectForKey:@"intro"];
        self.imageUrl = [jsonObj objectForKey:@"image"];
        self.link = [jsonObj objectForKey:@"link"];
    }
    return self;
}

- (void)dealloc
{
    self.title = self.subtitle = self.intro = self.imageUrl = self.link = nil;
    [super dealloc];
}

@end
