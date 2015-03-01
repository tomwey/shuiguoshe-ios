//
//  Apartment.h
//  shuiguoshe
//
//  Created by tomwey on 3/1/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Apartment : NSObject

@property (nonatomic, assign) NSInteger oid;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
