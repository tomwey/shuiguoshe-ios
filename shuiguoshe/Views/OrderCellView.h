//
//  OrderCellView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderInfo, LineItem;
@interface OrderCellView : UIView

- (void)setOrderInfo:(OrderInfo *)info;

@end

@interface OrderItemView : UIView

- (void)setItem:(LineItem *)item;

@end
