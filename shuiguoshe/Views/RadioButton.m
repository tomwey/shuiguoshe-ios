//
//  RadioButton.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "RadioButton.h"
#import "Defines.h"

@implementation RadioButton
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
        
        self.selected = NO;
    }
    return self;
}

- (void)btnClicked
{
    if ( self.valueChanged ) {
        self.valueChanged(self);
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if ( _selected ) {
        _contentView.image = [UIImage imageNamed:@"btn_checked.png"];
        self.userInteractionEnabled = NO;
    } else {
        _contentView.image = [UIImage imageNamed:@"btn_check.png"];
        self.userInteractionEnabled = YES;
    }
}

- (void)dealloc
{
    self.valueChanged = nil;
    [super dealloc];
}

@end
