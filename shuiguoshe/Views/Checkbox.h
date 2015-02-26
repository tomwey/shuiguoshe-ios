//
//  Checkbox.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

typedef NS_ENUM(NSInteger, CheckboxType) {
    CheckboxTypeSingle,
    CheckboxTypeSelectAll,
};

extern NSString * const kCheckboxDidUpdateStateNotification;

@class Checkbox;
typedef void (^CheckboxDidUpdateStateBlock)(Checkbox *);

@class CheckboxGroup;
@interface Checkbox : UIView

@property (nonatomic, assign) BOOL checked;

@property (nonatomic, copy) NSString* label;

@property (nonatomic, assign) CheckboxType checkboxType;

@property (nonatomic, assign) CheckboxGroup* checkboxGroup;

@property (nonatomic, retain) LineItem* currentItem;

@property (nonatomic, copy) CheckboxDidUpdateStateBlock didUpdateStateBlock;

@end

@interface CheckboxGroup : NSObject


@property (nonatomic, copy) NSArray* checkboxes;

- (void)addCheckbox:(Checkbox *)aCheckbox;

@end
