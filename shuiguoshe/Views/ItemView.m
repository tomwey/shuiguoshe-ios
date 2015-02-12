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
    
    LPLabel*     _originPriceLabel; // 市场价
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _discounted = NO;
        
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [RGB(224, 224, 224) CGColor];
        self.layer.borderWidth = 1;
        self.clipsToBounds = YES;
        
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
        _unitLabel.font = [UIFont systemFontOfSize:14];
        _unitLabel.textColor = RGB(80,80,80);
        
        // 价格
        _priceLabel = [[UILabel alloc] init];
        [self addSubview:_priceLabel];
        [_priceLabel release];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textColor = GREEN_COLOR;
        
        _originPriceLabel = [[LPLabel alloc] init];
        [self addSubview:_originPriceLabel];
        [_originPriceLabel release];
        _originPriceLabel.font = [UIFont systemFontOfSize:12];
        _originPriceLabel.textColor = RGB(137, 137, 137);
        _originPriceLabel.strikeThroughColor = _originPriceLabel.textColor;
        
        // 销售记录
        _saleCountLabel = [[UILabel alloc] init];
        [self addSubview:_saleCountLabel];
        [_saleCountLabel release];
        
        _saleCountLabel.backgroundColor = GREEN_COLOR;
        _saleCountLabel.textColor = [UIColor whiteColor];
        _saleCountLabel.font = [UIFont systemFontOfSize:12];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        
        [self addGestureRecognizer:tap];
        [tap release];
        
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)tap
{
    if ( self.didSelectBlock ) {
        self.didSelectBlock(self);
    } else {
        ForwardCommand* fc = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                              from:nil
                                                                                  toControllerName:@"ItemDetailViewController"]];
        fc.userData = self.item;
        [fc execute];
    }
}

- (void)setItem:(Item *)item
{
    if ( _item != item ) {
        [_item release];
        _item = [item retain];
        
        [_avatarView setImageWithURL:[NSURL URLWithString:item.thumbImageUrl] placeholderImage:nil];
        _titleLabel.text = item.title;
        _unitLabel.text = item.unit;
        _priceLabel.text = item.lowPriceText;
        _originPriceLabel.text = item.originPriceText;
        
        CGSize size2 = [_priceLabel.text sizeWithFont:_priceLabel.font
                                    constrainedToSize:
                        CGSizeMake(CGRectGetWidth(self.bounds),
                                   CGRectGetHeight(_priceLabel.bounds))
                                        lineBreakMode:_priceLabel.lineBreakMode];
        _priceLabel.bounds = CGRectMake(0, 0, size2.width, size2.height);
        
        NSString* str = [NSString stringWithFormat:@" 已售%d件 ", item.ordersCount];
        CGSize size = [str sizeWithFont:_saleCountLabel.font
                      constrainedToSize:CGSizeMake(CGRectGetWidth(self.bounds), 20)
                          lineBreakMode:_saleCountLabel.lineBreakMode];
        _saleCountLabel.bounds = CGRectMake(0, 0, size.width, 20);
        
        _saleCountLabel.text = str;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGFloat dt = 6;
    CGFloat width = CGRectGetWidth(bounds) - dt;
    _avatarView.frame = CGRectMake(dt/2, dt/2, width, width * 5 / 6);
    
    _titleLabel.frame = CGRectMake(10,
                                   CGRectGetMaxY(_avatarView.frame),
                                   CGRectGetWidth(bounds) - 20, 50);
    
    _unitLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame),
                                  CGRectGetMaxY(_titleLabel.frame) - 5,
                                  CGRectGetWidth(_titleLabel.frame),
                                  30);
    
    CGRect frame = _priceLabel.bounds;
    frame.origin = CGPointMake(CGRectGetMinX(_unitLabel.frame),
                               CGRectGetMaxY(_unitLabel.frame) - 5);
    _priceLabel.frame = frame;
    
    frame = _priceLabel.frame;
    frame.origin.x = CGRectGetMaxX(frame) + 3;
    _originPriceLabel.frame = frame;
    
    frame = _saleCountLabel.bounds;
    frame.origin = CGPointMake(CGRectGetMinX(_priceLabel.frame),
                               CGRectGetMaxY(_priceLabel.frame) + 3);
    _saleCountLabel.frame = frame;
}

- (void)dealloc
{
    self.didSelectBlock = nil;
    [_item release];
    
    [super dealloc];
}

@end
