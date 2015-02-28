//
//  ScoreTrace.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ScoreTrace.h"

@implementation ScoreTrace

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.operType = [jsonObj objectForKey:@"oper_type"];
        self.createdAt = [jsonObj objectForKey:@"created_at"];
        self.summary = [jsonObj objectForKey:@"summary"];
        self.score = [[jsonObj objectForKey:@"score"] integerValue];
    }
    return self;
}

- (void)dealloc
{
    self.summary = nil;
    self.operType = nil;
    self.createdAt = nil;
    
    [super dealloc];
}

@end
