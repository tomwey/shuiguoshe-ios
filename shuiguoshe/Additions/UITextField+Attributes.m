//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//


#import "UITextField+Attributes.h"

@implementation UITextField (Attributes)

@dynamic name;

static NSString* __name = nil;
- (void)setName:(NSString *)name
{
    [__name release];
    __name = [name copy];
}

- (NSString *)name
{
    return __name;
}

@end
