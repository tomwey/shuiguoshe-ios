//
//  HomeTtitleView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-5.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "HomeTitleView.h"
#import "Defines.h"

@implementation HomeTitleView
{
    UIImageView* _arrowView;
    UILabel*     _titleLabel;
}

- (void)dealloc
{
    self.titleDidClickBlock = nil;
    [_title release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.frame = CGRectMake(0, 0, 168, 44);
        
        CGRect frame = self.bounds;
        frame.size.width = 98;
        _titleLabel = createLabel(frame,
                                  NSTextAlignmentCenter,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:18]);
        [self addSubview:_titleLabel];
        _titleLabel.numberOfLines = 1;
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]];
        [self addSubview:_arrowView];
        [_arrowView release];
        
        [_arrowView sizeToFit];
        
        _arrowView.center = CGPointMake(100 + CGRectGetWidth(_arrowView.bounds)/2,
                                        CGRectGetMidY(self.bounds));
        
        UIButton* blankButton = createButton(nil, self, @selector(btnClicked));
        blankButton.frame = self.bounds;
        //        blankButton.backgroundColor = [UIColor redColor];
        [self addSubview:blankButton];
        
//        _isClosed = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [_title release];
    _title = [title copy];
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    CGFloat width = CGRectGetWidth(_titleLabel.bounds);
    
    _titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds),
                                     CGRectGetMidY(self.bounds));
    
    _arrowView.center = CGPointMake(CGRectGetMidX(self.bounds) + width / 2 + CGRectGetWidth(_arrowView.bounds)/2,
                                    CGRectGetMidY(self.bounds));
}

- (void)btnClicked
{
//    _isClosed = !_isClosed;
    if ( self.titleDidClickBlock ) {
        self.titleDidClickBlock();
    }
}

@end
