//
//  Command.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Command.h"


//typedef void (^ResultBlock)(id result);
//
//@interface Command ()
//
//@property (nonatomic, copy) ResultBlock resultBlock;
//
//@end
@implementation Command

- (void)execute
{
    [self execute:nil];
}

- (void)execute:( void (^)(id result))result
{
//    self.resultBlock = result;
    
    [NSException raise:@"must override method" format:@"必须重写此方法"];
}

- (void)dealloc
{
//    self.resultBlock = nil;
    self.userData = nil;
    [super dealloc];
}

@end
