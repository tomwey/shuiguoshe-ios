//
//  Forward.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Forward.h"

@implementation Forward

+ (id)buildForwardWithType:(ForwardType)type from:(UIViewController *)from toController:(UIViewController *)to
{
    Forward* aForward = [[[Forward alloc] init] autorelease];
    aForward.forwardType = type;
    aForward.from = from;
    aForward.to = to;
    return aForward;
}

+ (id)buildForwardWithType:(ForwardType)type from:(UIViewController *)from toControllerName:(NSString *)toController
{
    Forward* aForward = [[[Forward alloc] init] autorelease];
    aForward.forwardType = type;
    aForward.from = from;
    aForward.toController = toController;
    return aForward;
}

- (void)dealloc
{
    self.toController = nil;
    self.userData = nil;
    [super dealloc];
}

@end
