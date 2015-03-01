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
        
        decr = createButton(@"btn_decr.png", self, @selector(decrease:));
        [self addSubview:decr];
        
        CGRect frame = decr.frame;
        frame.origin = CGPointMake(5, CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(frame) / 2);
        decr.frame = frame;
        
        _valueLabel = createLabel(CGRectMake(CGRectGetMaxX(decr.frame), 0,
                                                     CGRectGetWidth(self.bounds) * 0.4,
                                                     CGRectGetHeight(self.bounds)),
                                          NSTextAlignmentCenter,
                                          [UIColor blackColor],
                                          [UIFont systemFontOfSize:12]);
        [self addSubview:_valueLabel];
//        _valueLabel.backgroundColor = [UIColor redColor];
        _valueLabel.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds));
        
        incr = createButton(@"btn_incr.png", self, @selector(increase:));
        
        [self addSubview:incr];
        
        frame = incr.frame;
        frame.origin = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetMinX(decr.frame) - CGRectGetWidth(frame), CGRectGetMinY(decr.frame));
        incr.frame = frame;
        
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
    } else {
        decr.enabled = YES;
    }
    
    if ( _value == self.maximumValue ) {
        incr.enabled = NO;
    } else {
        incr.enabled = YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kCartTotalDidChangeNotification object:@(-1)];
    [self updateQuantity];
}

- (void)increase:(UIButton *)sender
{
    self.value += self.step;
    [[NSNotificationCenter defaultCenter] postNotificationName:kCartTotalDidChangeNotification object:@(1)];
    [self updateQuantity];
}

- (void)dealloc
{
    self.finishUpdatingBlock = nil;
    [super dealloc];
}

@end
