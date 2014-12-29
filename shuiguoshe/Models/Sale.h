//
//  Sale.h
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sale : NSObject

@property (nonatomic, assign) NSUInteger sid;

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* subtitle;

@property (nonatomic, copy)   NSString* closedAt;

@property (nonatomic, copy)   NSString* logoUrl;
@property (nonatomic, copy)   NSString* coverImageUrl;

- (Sale *)initWithDictionary:(NSDictionary *)jsonObj;

@end
