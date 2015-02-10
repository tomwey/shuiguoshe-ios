//
//  OrderState.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderState.h"

@implementation OrderState

- (void)dealloc
{
    self.stateName = nil;
    [super dealloc];
}

+ (id)stateWithName:(NSString *)name quantity:(NSUInteger)quantity stateType:(OrderStateType)stateType
{
    OrderState* os = [[OrderState alloc] init];
    os.stateName = name;
    os.quantity = quantity;
    os.stateType = stateType;
    return [os autorelease];
}

@end
