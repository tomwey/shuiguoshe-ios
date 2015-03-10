//
//  RadioButton.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;

typedef void (^RadioButtonValueChangedBlock)(RadioButton*);
@interface RadioButton : UIView

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) RadioButtonValueChangedBlock valueChanged;

@end
