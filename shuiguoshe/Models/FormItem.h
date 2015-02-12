//
//  FormItem.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormItem : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, copy) NSString* value;

@end
