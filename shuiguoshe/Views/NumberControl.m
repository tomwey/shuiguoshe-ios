//
//  NumberControl.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NumberControl.h"
#import "Defines.h"

@implementation NumberControl
{
    UIImageView* _bgView;
    UILabel*     _valueLabel;
    
    UIButton* decr;
    UIButton* incr;
    
    BOOL _updating;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.minimumValue = 1;
        self.maximumValue = NSIntegerMax;
        self.step = 1;
        
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number_control_bg.png"]];
        [self addSubview:_bgView];
        [_bgView release];
        
        [_bgView sizeToFit];
        
        self.bounds = _bgView.bounds;
        
        decr = [UIButton buttonWithType:UIButtonTypeCustom];
        [decr setTitle:@"—" forState:UIControlStateNormal];
        [decr setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        decr.exclusiveTouch = YES;
        [self addSubview:decr];
        [decr addTarget:self action:@selector(decrease:) forControlEvents:UIControlEventTouchUpInside];
        
        decr.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.3,CGRectGetHeight(self.bounds));
        
        _valueLabel = createLabel(CGRectMake(CGRectGetMaxX(decr.frame), 0,
                                                     CGRectGetWidth(self.bounds) * 0.4,
                                                     CGRectGetHeight(self.bounds)),
                                          NSTextAlignmentCenter,
                                          [UIColor blackColor],
                                          [UIFont systemFontOfSize:12]);
        [self addSubview:_valueLabel];
        
        incr = [UIButton buttonWithType:UIButtonTypeCustom];
        [incr setTitle:@"+" forState:UIControlStateNormal];
        [incr setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self addSubview:incr];
        [incr addTarget:self action:@selector(increase:) forControlEvents:UIControlEventTouchUpInside];
        
        incr.frame = CGRectMake(CGRectGetWidth(self.bounds) * 0.7, 0, CGRectGetWidth(self.bounds) * 0.3,CGRectGetHeight(self.bounds));
        incr.exclusiveTouch = YES;
        self.value = 1;
        
    }
    return self;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    _valueLabel.text = NSStringFromInteger(value);
    
    if ( _value == self.minimumValue ) {
        decr.enabled = NO;
        [decr setTitleColor:RGB(213, 213, 213) forState:UIControlStateNormal];
    } else {
        decr.enabled = YES;
        [decr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ( _value == self.maximumValue ) {
        incr.enabled = NO;
        [incr setTitleColor:RGB(213, 213, 213) forState:UIControlStateNormal];
    } else {
        incr.enabled = YES;
        [incr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)updateQuantity
{
    if ( _updating ) {
        return;
    }
    
    _updating = YES;
    
    __block NumberControl* me = self;
    [[DataService sharedService] post:@"/cart/update_item"
                               params:@{ @"token": [[UserService sharedService] token],
                                         @"id" : NSStringFromInteger(self.itemId) ,
                                         @"quantity": NSStringFromInteger(self.value)  }
                           completion:^(id result, BOOL succeed) {
                               _updating = NO;
                               if ( succeed && me.finishUpdatingBlock ) {
                                   me.finishUpdatingBlock(me.value);
                               }
                           }];
}

- (void)decrease:(UIButton *)sender
{
    self.value -= self.step;
    
    [self updateQuantity];
}

- (void)increase:(UIButton *)sender
{
    self.value += self.step;
    
    [self updateQuantity];
}

- (void)dealloc
{
    self.finishUpdatingBlock = nil;
    [super dealloc];
}

@end
