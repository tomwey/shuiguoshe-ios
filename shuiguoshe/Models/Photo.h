//
//  Photo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@interface Photo : NSObject

@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, assign) float imageWidth;
@property (nonatomic, assign) float imageHeight;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

- (CGFloat)scaledImageWidth;
- (CGFloat)scaledImageHeight;

@end
