//
//  UpdateValueLabel.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-26.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "UpdateValueLabel.h"

@implementation UpdateValueLabel

- (void)dealloc
{
    self.prefix = nil;
    self.value = nil;
    [super dealloc];
}

- (void)setValue:(id)value
{
    [_value release];
    _value = [value retain];
    
    NSString* prefix = !!self.prefix ? self.prefix : @"";
    self.text = [NSString stringWithFormat:@"%@%@", prefix, value];
}

@end
