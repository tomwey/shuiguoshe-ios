//
//  ShareView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ShareView.h"
#import "Defines.h"

#define kShareButtonsCount 3
#define kNumberOfCols      3
#define kVerticalPadding   20.0

static NSString* buttonImages[kShareButtonsCount] = {
    @"share_wexin.png",
    @"share_weixinFriend.png",
    @"share_Qzone.png"
};

static NSString* buttonTips[kShareButtonsCount] = {
    @"微信好友",
    @"微信朋友圈",
    @"QQ空间"
};

static NSString* commands[kShareButtonsCount] = {
    @"Share2WeiXinCommand",
    @"Share2WeiXinFriendsCommand",
    @"Share2QzoneCommand",
};

@implementation ShareView
{
    UIView* _maskView;
    UIView* _shareButtonsContainer;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.frame = mainScreenBounds;
        
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .6;
        
        [self addSubview:_maskView];
        [_maskView release];
        
        _shareButtonsContainer = [[UIView alloc] initWithFrame:self.bounds];
        _shareButtonsContainer.backgroundColor = [UIColor whiteColor];
        [self addSubview:_shareButtonsContainer];
        [_shareButtonsContainer release];
        
        // 上边线
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),2)];
        topLine.backgroundColor = GREEN_COLOR;
        [_shareButtonsContainer addSubview:topLine];
        [topLine release];
        
        // 分享按钮
        CGFloat height = 0;
        for (int i=0; i<kShareButtonsCount; i++) {
            UIButton* shareBtn = createButton(buttonImages[i], self, @selector(btnClicked:));
            [_shareButtonsContainer addSubview:shareBtn];
            shareBtn.tag = 100 + i;
            
            int m = i % kNumberOfCols;
            int n = i / kNumberOfCols;
            
            CGFloat btnWidth  = CGRectGetWidth(shareBtn.bounds);
            CGFloat btnHeight = CGRectGetHeight(shareBtn.bounds);
            
            CGFloat horizontalPadding = ( CGRectGetWidth(mainScreenBounds) - btnWidth * kNumberOfCols ) / ( kNumberOfCols + 1 );
            
            CGFloat x = horizontalPadding + btnWidth / 2.0 + ( horizontalPadding + btnWidth ) * m;
            CGFloat y = kVerticalPadding + btnHeight / 2.0 + ( kVerticalPadding + btnHeight ) * n;
            
            shareBtn.center = CGPointMake(x, y);
            
            // 按钮提示
            CGRect frame = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds) / kNumberOfCols, 37);
            UILabel* tipLabel = createLabel(frame, NSTextAlignmentCenter, RGB(137, 137, 137), [UIFont systemFontOfSize:14]);
            [_shareButtonsContainer addSubview:tipLabel];
            tipLabel.text = buttonTips[i];
            
            tipLabel.center = CGPointMake(shareBtn.center.x, CGRectGetMaxY(shareBtn.frame) + CGRectGetHeight(frame) / 2);
            
            height = CGRectGetMaxY(tipLabel.frame);
        }
        
        // 分隔线
        UIView* splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, height + 10, CGRectGetWidth(self.frame),1)];
        splitLine.backgroundColor = RGB(203, 203, 203);
        [_shareButtonsContainer addSubview:splitLine];
        [splitLine release];
        
        // 取消按钮
        UIButton* cancelBtn = createButton2(nil, @"取消", self, @selector(dismiss));
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(splitLine.frame), CGRectGetWidth(mainScreenBounds), 44);
        [_shareButtonsContainer addSubview:cancelBtn];
        
        CGRect frame = _shareButtonsContainer.frame;
        frame.size.height = CGRectGetMaxY(cancelBtn.frame);
        _shareButtonsContainer.frame = frame;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender
{
    Command* aCommand = [[[NSClassFromString(commands[sender.tag - 100]) alloc] init] autorelease];
    aCommand.userData = self.itemDetail;
    [aCommand execute];
}

- (void)dismiss
{
    _maskView.hidden = YES;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:.3
                     animations:^{
                         CGRect frame = _shareButtonsContainer.frame;
                         frame.origin.y = CGRectGetHeight(mainScreenBounds);
                         _shareButtonsContainer.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

- (void)showInView:(UIView *)superView
{
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    [superView bringSubviewToFront:self];
    
    CGRect frame = _shareButtonsContainer.frame;
    frame.origin.y = CGRectGetHeight(mainScreenBounds);
    _shareButtonsContainer.frame = frame;
    
    _maskView.hidden = YES;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:.3
                     animations:^{
                         CGRect frame2 = _shareButtonsContainer.frame;
                         frame2.origin.y = CGRectGetHeight(mainScreenBounds) - CGRectGetHeight(frame2);
                         _shareButtonsContainer.frame = frame2;
                     } completion:^(BOOL finished) {
                         _maskView.hidden = NO;
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

@end
