//
//  ForwardCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ForwardCommand.h"

#import "Defines.h"

@implementation ForwardCommand

- (void)execute:(void (^)(id))result
{
    if ( [self checkLogin] && ![[UserService sharedService] isLogin] ) {
        self.forward.toController = @"LoginViewController";
    }
    
    self.forward.userData = self.userData;
    [[CoordinatorController sharedInstance] forwardTo:self.forward];
}

- (BOOL)checkLogin
{
    NSArray* controllers = @[@"UserViewController", @"CartViewController"];
    return [controllers containsObject:self.forward.toController];
}

+ (ForwardCommand *)buildCommandWithForward:(Forward *)aForward
{
    ForwardCommand* fc = [[[ForwardCommand alloc] init] autorelease];
    fc.forward = aForward;
    return fc;
}

- (void)dealloc
{
    self.forward = nil;
    [super dealloc];
}

@end
