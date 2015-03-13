//
//  RequestErrorView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-13.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "RequestErrorView.h"
#import "Defines.h"

@implementation RequestErrorView
{
    UIImageView* _contentView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _contentView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_logo.png"]] autorelease];
        [self addSubview:_contentView];
        
        _contentView.frame = CGRectMake(0, 0, 88, 88);
        
        _contentView.center = CGPointMake(CGRectGetMidX(mainScreenBounds),
                                          CGRectGetMidY(mainScreenBounds) - 10);
        
        self.frame = mainScreenBounds;
        
        UILabel* label = createLabel(CGRectMake(CGRectGetMinX(_contentView.frame),
                                                CGRectGetMaxY(_contentView.frame),
                                                88, 24),
                                     NSTextAlignmentCenter,
                                     COMMON_TEXT_COLOR,
                                     [UIFont systemFontOfSize:fontSize(12)]);
        label.text = @"点击重新加载";
        
        [self addSubview:label];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        [tap release];
    }
    return self;
}

- (void)tap
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadDataNotification"
                                                        object:self.requestURI];
}

- (void)dealloc
{
    self.requestURI = nil;
    [super dealloc];
}

@end
