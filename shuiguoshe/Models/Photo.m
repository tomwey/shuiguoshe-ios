//
//  Photo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.imageUrl = [jsonObj objectForKey:@"url"];
        self.imageWidth = [[jsonObj objectForKey:@"width"] floatValue];
        self.imageHeight = [[jsonObj objectForKey:@"height"] floatValue];
    }
    return self;
}


- (CGFloat)scaledImageWidth
{
    if ( self.imageWidth == 0 ) {
        return 0;
    }
    
    CGFloat width = CGRectGetWidth(mainScreenBounds);
    width = width - 30;
    
    return MIN(width, self.imageWidth);
}

- (CGFloat)scaledImageHeight
{
    if ( self.imageHeight == 0 ) {
        return 0;
    }
    
    CGFloat factor = self.imageWidth / self.imageHeight;
    return self.scaledImageWidth / factor;
}

- (void)dealloc
{
    self.imageUrl = nil;
    [super dealloc];
}

@end
