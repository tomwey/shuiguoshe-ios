//
//  Section.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-2.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Section.h"

@implementation Section

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.name = [jsonObj objectForKey:@"name"];
        self.identifier = [jsonObj objectForKey:@"identifier"];
        self.height = [[jsonObj objectForKey:@"height"] floatValue];
        
        NSString* dataType = [jsonObj objectForKey:@"data_type"];
        self.dataType = dataType;
        
        NSMutableArray* temp = [NSMutableArray array];
        for (id dict in [jsonObj objectForKey:@"data"]) {
            id obj = [[NSClassFromString(dataType) alloc] initWithDictionary:dict];
            [temp addObject:obj];
            [obj release];
        }
        
        self.data = temp;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.identifier = nil;
    self.dataType = nil;
    self.data = nil;
    [super dealloc];
}

@end
