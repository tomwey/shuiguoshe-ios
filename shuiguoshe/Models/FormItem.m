//
//  FormItem.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "FormItem.h"

@implementation FormItem

- (void)dealloc
{
    self.name = nil;
    self.label = nil;
    self.placeholder = nil;
    self.value = nil;
    [super dealloc];
}

@end