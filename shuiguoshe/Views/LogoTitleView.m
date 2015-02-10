//
//  LogoTitleView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "LogoTitleView.h"

@implementation LogoTitleView
{
    UIImageView* _contentView;
    UIImageView* _arrowView;
    
    BOOL  _isClosed;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_title.png"]];
        [self addSubview:_contentView];
        [_contentView release];
        
        [_contentView sizeToFit];
        
        CGRect bounds = _contentView.bounds;
        bounds.size.height = 44;
        self.bounds = bounds;
        
        CGRect frame = _contentView.bounds;
        frame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frame)) / 2;
        _contentView.frame = frame;
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
        [self addSubview:_arrowView];
        [_arrowView release];
        
        [_arrowView sizeToFit];
        
        frame = _arrowView.frame;
        frame.origin = CGPointMake(CGRectGetWidth(self.bounds) * 0.75, CGRectGetHeight(self.bounds) * 0.3);
        _arrowView.frame = frame;
        
        UIButton* blankButton = createButton(nil, self, @selector(btnClicked));
        blankButton.frame = self.bounds;
//        blankButton.backgroundColor = [UIColor redColor];
        [self addSubview:blankButton];
        
        _isClosed = YES;
    }
    return self;
}

- (void)btnClicked
{
    _isClosed = !_isClosed;
    
    if ( _isClosed ) {
        _arrowView.image = [UIImage imageNamed:@"down_arrow.png"];
    } else {
        _arrowView.image = [UIImage imageNamed:@"up_arrow.png"];
    }
    
    BOOL flag = _isClosed;
    if ( self.didClickBlock ) {
        self.didClickBlock(flag);
    }
}

- (void)dealloc
{
    self.didClickBlock = nil;
    [super dealloc];
}

@end
