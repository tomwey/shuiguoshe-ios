//
//  OrderStateView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderStateView.h"

@interface OrderStateView ()

@property (nonatomic, retain) OrderState* internalOrderState;

@end

@implementation OrderStateView
{
    UIButton* _tapButton;
    UILabel*  _quantityLabel;
    UILabel*  _stateLabel;
    UIView*   _rightLine;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        _tapButton = createButton(nil, self, @selector(btnClicked));
        [self addSubview:_tapButton];
        
        _quantityLabel = createLabel(CGRectZero, NSTextAlignmentCenter, COMMON_TEXT_COLOR, [UIFont systemFontOfSize:20]);
        [self addSubview:_quantityLabel];
        
        _stateLabel = createLabel(CGRectZero, NSTextAlignmentCenter, COMMON_TEXT_COLOR, [UIFont systemFontOfSize:18]);
        [self addSubview:_stateLabel];
        
        _rightLine = [[[UIView alloc] init] autorelease];
        [self addSubview:_rightLine];
        _rightLine.backgroundColor = RGB(224, 224, 224);
        
        self.shouldShowingRightLine = YES;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tapButton.frame = self.bounds;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds)/2);
    
    _quantityLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 37);
    _quantityLabel.center = CGPointMake(center.x, center.y - 15);
    
    _stateLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 37);
    _stateLabel.center = CGPointMake(center.x, center.y + 15);
    
    if ( self.shouldShowingRightLine ) {
        CGFloat height = CGRectGetHeight(self.bounds) * 0.9;
        _rightLine.frame = CGRectMake(CGRectGetWidth(self.bounds) - 1, ( CGRectGetHeight(self.bounds) - height ) / 2, 1, height);
    }
}

- (void)btnClicked
{
    if ( self.didSelectBlock ) {
        self.didSelectBlock(self.internalOrderState);
    }
}

- (void)setOrderState:(OrderState *)aState
{
    self.internalOrderState = aState;
    
    _quantityLabel.text = NSStringFromInteger(aState.quantity);
    
    _stateLabel.text = aState.stateName;
}

- (void)setShouldShowingRightLine:(BOOL)shouldShowingRightLine
{
    _shouldShowingRightLine = shouldShowingRightLine;
    _rightLine.hidden = !_shouldShowingRightLine;
}

- (void)dealloc
{
    self.internalOrderState = nil;
    self.didSelectBlock = nil;
    
    [super dealloc];
}

@end
