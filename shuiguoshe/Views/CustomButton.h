//
//  CustomButton.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomButton;
@class CustomButtonGroup;

typedef void (^ButtonDidClickBlock)(CustomButton*);

@interface CustomButton : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) ButtonDidClickBlock didClickBlock;

@property (nonatomic, assign) CustomButtonGroup* buttonGroup;

- (void)setTitle:(NSString*)title;
- (NSString *)title;

@end

@interface CustomButtonGroup : NSObject

- (void)addCustomButton:(CustomButton*)aButton;

- (void)removeAllButtons;

- (NSArray *)items;

@end
