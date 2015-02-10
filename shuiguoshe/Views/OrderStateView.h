//
//  OrderStateView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@class OrderState;
typedef void (^OrderStateDidSelectBlock)(OrderState *);

@interface OrderStateView : UIView

- (void)setOrderState:(OrderState *)aState;

// 默认值为YES
@property (nonatomic, assign) BOOL shouldShowingRightLine;

@property (nonatomic, copy) OrderStateDidSelectBlock didSelectBlock;

@end
