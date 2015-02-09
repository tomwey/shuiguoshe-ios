//
//  ItemView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView
{
    UIImageView* _avatarView; // icon
    UILabel*     _titleLabel; // 标题
    UILabel*     _unitLabel;  // 规格
    UILabel*     _priceLabel; // 价格
    UILabel*     _saleCountLabel; // 销售记录
    UILabel*     _timeLeftLabel;  // 倒计时
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _discounted = NO;
        
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [RGB(213, 213, 213) CGColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _avatarView = [[UIImageView alloc] init];
        [self addSubview:_avatarView];
        [_avatarView release];
        
        // 标题
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel release];
        
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        // 规格
        _unitLabel = [[UILabel alloc] init];
        [self addSubview:_unitLabel];
        [_unitLabel release];
        
        _unitLabel.textColor = RGB(213, 213, 213);
        
        // 价格
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        [_priceLabel release];
        
        // 销售记录
        _saleCountLabel = [[UILabel alloc] init];
        [self addSubview:_saleCountLabel];
        [_saleCountLabel release];
        
        _saleCountLabel.backgroundColor = RGB(7,156,22);
        _saleCountLabel.textColor = [UIColor whiteColor];
        _saleCountLabel.font = [UIFont systemFontOfSize:10];
        
    }
    return self;
}

- (void)setItem:(Item *)item
{
    if ( _item != item ) {
        [_item release];
        _item = [item retain];
        
        [_avatarView setImageWithURL:[NSURL URLWithString:item.thumbImageUrl] placeholderImage:nil];
        _unitLabel.text = item.unit;
        _priceLabel.text = item.lowPrice;
        _saleCountLabel.text = [@(item.ordersCount) description];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGFloat width = CGRectGetWidth(bounds) - 10;
    _avatarView.frame = CGRectMake(5, 5, width, width * 5 / 6);
    
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_avatarView.frame),
                                   CGRectGetMaxY(_avatarView.frame),
                                   width, 50);
    _unitLabel.frame = CGRectMake(CGRectGetMinX(_avatarView.frame),
                                  CGRectGetMaxY(_titleLabel.frame),
                                  CGRectGetWidth(_titleLabel.frame),
                                  37);
    CGRect frame = _unitLabel.frame;
    frame.origin.y = CGRectGetMaxY(frame);
    _priceLabel.frame = frame;
    
    
}

- (void)dealloc
{
    self.didSelectBlock = nil;
    [_item release];
    
    [super dealloc];
}

@end
