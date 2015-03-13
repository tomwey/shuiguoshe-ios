//
//  OrderState.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OrderStateType) {
    OrderStateTypeDelivering,
    OrderStateTypeNoPay,
    OrderStateTypeDone,
    OrderStateTypeCanceled,
};

@interface OrderState : NSObject

@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, copy) NSString* stateName;
@property (nonatomic, assign) OrderStateType stateType;

+ (id)stateWithName:(NSString *)name quantity:(NSUInteger)quantity stateType:(OrderStateType)stateType;

@end
