//
//  Checkbox.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Checkbox.h"
#import "Defines.h"

NSString * const kCheckboxDidUpdateStateNotification = @"kCheckboxDidUpdateStateNotification";

#define kUpdateSelectAllStateNotification @"kUpdateSelectAllStateNotification"

@implementation Checkbox
{
    UIImageView* _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.bounds = CGRectMake(0, 0, 44, 44);
        
        _contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_check.png"]];
        [self addSubview:_contentView];
        [_contentView release];
        
        [_contentView sizeToFit];
        
        _contentView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                          CGRectGetMidY(self.bounds));
        
        
        UIButton* btn = createButton(nil, self, @selector(btnClicked));
        [self addSubview:btn];
        btn.frame = self.bounds;
        
        self.checked = YES;
        
        self.checkboxType = CheckboxTypeSingle;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateSelectAll:)
                                                     name:kUpdateSelectAllStateNotification
                                                   object:nil];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if ( _checked ) {
        _contentView.image = [UIImage imageNamed:@"btn_checked.png"];
    } else {
        _contentView.image = [UIImage imageNamed:@"btn_check.png"];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckboxDidUpdateStateNotification object:self];
}

- (void)setLabel:(NSString *)label
{
    [_label release];
    _label = [label copy];
    
    if ( label ) {
        UILabel* realLabel = (UILabel *)[self viewWithTag:1024];
        if ( !realLabel ) {
            realLabel = createLabel(CGRectZero, NSTextAlignmentLeft, [UIColor blackColor], [UIFont systemFontOfSize:16]);
            [self addSubview:realLabel];
            realLabel.tag = 1024;
            
            CGSize size = [label sizeWithFont:realLabel.font
                            constrainedToSize:CGSizeMake(5000, CGRectGetHeight(self.bounds))
                                lineBreakMode:realLabel.lineBreakMode];
            
            realLabel.frame = CGRectMake(CGRectGetMaxX(_contentView.frame) + 5,
                                         0, size.width, CGRectGetHeight(self.bounds));
        }
        realLabel.text = label;
        CGRect frame = self.frame;
        frame.size.width += CGRectGetWidth(realLabel.frame);
        self.frame = frame;
    }
}

- (void)btnClicked
{
    int state = self.checked ? 0 : 1;
    
    NSString* idString = nil;
    if ( self.checkboxType == CheckboxTypeSelectAll ) {
        NSMutableArray* ids = [NSMutableArray array];
        for ( Checkbox* cb in self.checkboxGroup.checkboxes ) {
            if ( cb != self ) {
                [ids addObject:NSStringFromInteger(cb.currentItem.objectId)];
            }
        }
        
        idString = [ids componentsJoinedByString:@","];
    } else {
        idString = NSStringFromInteger(self.currentItem.objectId);
    }
    
    [[DataService sharedService] post:@"/cart/update_states" params:@{ @"token": [[UserService sharedService] token],
                                                                       @"ids": idString,
                                                                       @"state": NSStringFromInteger(state) }
                           completion:^(id result, BOOL succeed) {
                               if ( succeed ) {
                                   self.checked = !self.checked;
                                   if ( self.checkboxType == CheckboxTypeSelectAll ) { // 全选按钮
                                       for ( Checkbox* cb in self.checkboxGroup.checkboxes ) {
                                           if ( cb != self ) {
                                               cb.checked = self.checked;
                                           }
                                       }
                                   } else { // 单个按钮
                                       BOOL flag = YES;
                                       for ( Checkbox* cb in self.checkboxGroup.checkboxes ) {
                                           if ( cb.checkboxType == CheckboxTypeSingle ) {
                                               flag &= cb.checked;
                                           }
                                       }
                                       
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateSelectAllStateNotification
                                                                                           object:nil
                                                                                         userInfo:@{ @"state": NSStringFromInteger(flag) }];
                                   }
                                   
                                   if ( self.didUpdateStateBlock ) {
                                       self.didUpdateStateBlock(self);
                                   }
                                   
                               } else {
                                   [Toast showText:@"更新状态失败"];
                               }
                           }];
    
}

- (void)updateSelectAll:(NSNotification *)noti
{
    if ( self.checkboxType == CheckboxTypeSelectAll ) {
        self.checked = [[[noti userInfo] objectForKey:@"state"] boolValue];
    }
}

- (void)setCheckboxGroup:(CheckboxGroup *)checkboxGroup
{
    _checkboxGroup = checkboxGroup;
    [_checkboxGroup addCheckbox:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.currentItem = nil;
    [_label release];
    self.didUpdateStateBlock = nil;
    
    [super dealloc];
}

@end

@implementation CheckboxGroup
{
    NSMutableArray* _checkboxes;
}

@synthesize checkboxes = _checkboxes;

- (void)addCheckbox:(Checkbox *)aCheckbox
{
    if ( !_checkboxes ) {
        _checkboxes = [[NSMutableArray alloc] init];
    }
    
    if ( ![_checkboxes containsObject:aCheckbox] ) {
        [_checkboxes addObject:aCheckbox];
    }
}

- (void)dealloc
{
    [_checkboxes release];
    [super dealloc];
}

@end
