//
//  PhoneNumberView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "PhoneNumberView.h"

@implementation PhoneNumberView
{
    UIView* _maskView;
    UIView* _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.frame = mainScreenBounds;
        
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = COMMON_TEXT_COLOR;
        _maskView.alpha = .5;
        [self addSubview:_maskView];
        [_maskView release];
        
        _maskView.hidden = YES;
        
        CGRect frame = self.bounds;
        frame.size.height = CGRectGetWidth(mainScreenBounds) / 320.0 * 140;
        
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        [_contentView release];
        
        UIButton* phoneBtn = createButton(@"btn_phone.png", self, @selector(btnClicked));
        [_contentView addSubview:phoneBtn];
        phoneBtn.center = CGPointMake(CGRectGetWidth(_contentView.bounds) * .5,
                                      CGRectGetHeight(_contentView.bounds) * .5 - CGRectGetHeight(phoneBtn.bounds) / 2);
        
        UILabel* phoneNumber = createLabel(CGRectMake(0, CGRectGetHeight(_contentView.bounds) / 2 + 15,
                                                      CGRectGetWidth(_contentView.bounds),
                                                      40),
                                           NSTextAlignmentCenter,
                                           COMMON_TEXT_COLOR,
                                           [UIFont boldSystemFontOfSize:20]);
        [_contentView addSubview:phoneNumber];
        
        phoneNumber.text = @"订购热线：028-61361970";
    }
    
    return self;
}

+ (id)currentPhoneNumberView
{
    return [[[PhoneNumberView alloc] init] autorelease];
}

- (void)showInView:(UIView *)superView
{
    if ( self.superview ) {
        return;
    }
    
    [superView addSubview:self];
    
    [superView bringSubviewToFront:self];
    
    __block CGRect frame = _contentView.frame;
    frame.origin.y = - CGRectGetHeight(frame);
    _contentView.frame = frame;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         frame.origin.y = 64;
                         _contentView.frame = frame;
                     } completion:^(BOOL finished) {
                         _maskView.hidden = NO;
                     }];
}

- (void)dismiss
{
    __block CGRect frame = _contentView.frame;
    
    [UIView animateWithDuration:.5
                     animations:^{
                         frame.origin.y = - CGRectGetHeight(frame);
                         _contentView.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)btnClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:02861361970"]];
}

@end
