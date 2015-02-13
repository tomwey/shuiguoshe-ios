//
//  ItemDetail.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ItemDetail.h"

@implementation ItemDetail

- (id)initWithDictionary:(NSDictionary *)jsonResult
{
    if ( self = [super init] ) {
        self.largeImage = [jsonResult objectForKey:@"large_image"];
        self.note = [jsonResult objectForKey:@"note"];
        self.deliverInfo = [jsonResult objectForKey:@"deliver_info"];
        
        self.likesCount = [[jsonResult objectForKey:@"likes_count"] integerValue];
        
        NSMutableArray* temp = [NSMutableArray array];
        NSArray* photos = [jsonResult objectForKey:@"intro_images"];
        for (id item in photos) {
            Photo* p = [[[Photo alloc] initWithDictionary:item] autorelease];
            [temp addObject:p];
        }
        
        self.photos = [NSArray arrayWithArray:temp];
    }
    
    return self;
}

- (CGFloat)totalHeightForImages
{
    CGFloat height = 0;
    for (Photo* p in self.photos) {
        height += p.scaledImageHeight;
    }
    return height;
}

- (void)dealloc
{
    self.largeImage = nil;
    self.note = nil;
    self.deliverInfo = nil;
    self.photos = nil;
    
    [super dealloc];
}

@end
