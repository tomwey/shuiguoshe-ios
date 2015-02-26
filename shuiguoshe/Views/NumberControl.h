//
//  NumberControl.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishUpdatingBlock)(NSInteger);

@interface NumberControl : UIView

// 控件的当前值，默认为1
@property (nonatomic, assign) NSInteger value;

// 最小值, 默认为1
@property (nonatomic, assign) NSInteger minimumValue;

// 最大值，默认为最大整数
@property (nonatomic, assign) NSInteger maximumValue;

// 步长，默认为1
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, assign) NSInteger itemId;

@property (nonatomic, copy) FinishUpdatingBlock finishUpdatingBlock;

@end
