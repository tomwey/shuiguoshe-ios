//
//  Banner.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banner : NSObject

@property (nonatomic, assign) NSUInteger bid;

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* subtitle;
@property (nonatomic, copy)   NSString* intro;
@property (nonatomic, copy)   NSString* imageUrl;
@property (nonatomic, copy)   NSString* link;

- (Banner *)initWithDictionary:(NSDictionary *)jsonObj;

@end
