//
//  Section.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-2.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* identifier;
@property (nonatomic, copy) NSString* dataType;

@property (nonatomic, copy) NSArray* data;
@property (nonatomic, assign) float height;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
