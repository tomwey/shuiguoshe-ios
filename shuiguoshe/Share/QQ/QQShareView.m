//
//  QQShareView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "QQShareView.h"
#import "Defines.h"

NSString * const kShareViewDidSendNotification = @"kShareViewDidSendNotification";

@implementation QQShareView
{
    UIView* _maskView;
    UIImageView* _imageView;
    
    UITextField* _textField;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        CGRect bounds = [[UIScreen mainScreen] bounds];
        
        self.frame = bounds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        // header
        UIView* navBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]), CGRectGetWidth(self.frame), 44)];
        navBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:navBar];
        [navBar release];
        
        UIView* lineView =  [[UIView alloc] initWithFrame:CGRectMake(0, 43, CGRectGetWidth(self.frame), 1)];
        lineView.backgroundColor = RGB(203, 203, 203);
        [navBar addSubview:lineView];
        [lineView release];
        
        UIButton* closeBtn = createButton(@"btn_close.png", self, @selector(close));
        CGRect frame = closeBtn.frame;
        frame.origin = CGPointMake(15, CGRectGetHeight(navBar.frame) / 2 - CGRectGetHeight(frame) / 2);
        closeBtn.frame = frame;
        
        [navBar addSubview:closeBtn];
        
        frame = closeBtn.frame;
        frame.origin.x = CGRectGetWidth(self.frame) - 15 - CGRectGetWidth(frame);
        
        UIButton* sendBtn = createButton2(nil, @"分享", self, @selector(send));
        sendBtn.frame = frame;
        
        [sendBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
        
        [navBar addSubview:sendBtn];
        
        CGRect labelFrame = CGRectMake(0, 0, 200, 37);
        UILabel* titleLabel = createLabel(labelFrame,
                                          NSTextAlignmentCenter,
                                          COMMON_TEXT_COLOR,
                                          [UIFont systemFontOfSize:16]);
        titleLabel.center = CGPointMake(CGRectGetMidX(navBar.bounds), CGRectGetMidY(navBar.bounds) );
        titleLabel.text = @"分享到QQ空间";
        [navBar addSubview:titleLabel];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView release];
        
        
    }
    return self;
}

- (void)setShareInfo:(NSDictionary *)shareInfo
{
    if ( _shareInfo != shareInfo ) {
        [_shareInfo release];
        _shareInfo = [shareInfo mutableCopy];
        
        _imageView.image = [[UIImageView sharedImageCache] cachedImageForRequest:
                            [NSURLRequest requestWithURL:[NSURL URLWithString:[shareInfo objectForKey:@"imageUrl"]]]];
        CGFloat factor = _imageView.image.size.width / _imageView.image.size.height;
        
        CGFloat width = CGRectGetWidth(mainScreenBounds) * 0.5;
        
        _imageView.frame = CGRectMake(CGRectGetWidth(mainScreenBounds) / 2 - width / 2, 70, width,
                                      width / factor ) ;
        
        
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame) - 20 ,
                                                                   CGRectGetMaxY(_imageView.frame),
                                                                   CGRectGetWidth(_imageView.frame) + 40,
                                                                   37)];
        [self addSubview:_textField];
        [_textField release];
        
        _textField.placeholder = @"说点什么吧！限40字以内";
    }
}

- (void)close
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:.3
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.y = CGRectGetHeight(frame);
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

- (void)send
{
    if ( _textField.text.length > 0 ) {
        [_shareInfo setObject:_textField.text forKey:@"message"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShareViewDidSendNotification object:self];
}

- (void)show
{
    UIView* superView = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if ( !self.superview ) {
        [superView addSubview:self];
    }
    
    [superView bringSubviewToFront:self];
    
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(frame);
    self.frame = frame;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateWithDuration:.3
                     animations:^{
                         self.frame = mainScreenBounds;
                     } completion:^(BOOL finished) {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

- (void)dealloc
{
    [_shareInfo release];
    
    [super dealloc];
}

@end
