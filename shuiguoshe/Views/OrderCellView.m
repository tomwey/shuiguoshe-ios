//
//  OrderCellView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderCellView.h"
#import "Defines.h"

@implementation OrderCellView
{
    UIView* _topLine;
    UIView* _bottomLine;
    
    UIView* _headerView;
    UIView* _bodyView;
    UIView* _footerView;
    
    UILabel* _orderNo;
    UILabel* _resultLabel;
    
    UILabel* _orderTimeLabel;
    
    int _orderId;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor whiteColor];
        
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 1)];
        _topLine.backgroundColor = RGB(207, 207, 207);
        [self addSubview:_topLine];
        [_topLine release];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 1)];
        _bottomLine.backgroundColor = _topLine.backgroundColor;
        [self addSubview:_bottomLine];
        [_bottomLine release];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),60)];
        [self addSubview:_headerView];
        [_headerView release];
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),40)];
        [self addSubview:_footerView];
        [_footerView release];
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),40)];
        [self addSubview:_bodyView];
        [_bodyView release];
        
        CGFloat leftMargin = 15;
        _orderNo = createLabel(CGRectMake(leftMargin, 10, 240, 25),
                                       NSTextAlignmentLeft,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:12]);
        [_headerView addSubview:_orderNo];
        
        _resultLabel = createLabel(CGRectMake(leftMargin, 2, 240, 36),
                               NSTextAlignmentLeft,
                               COMMON_TEXT_COLOR,
                               [UIFont systemFontOfSize:12]);
        [_footerView addSubview:_resultLabel];
        
        
        UIView* lineView = [[[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(_headerView.frame) - 1,
                                                                    CGRectGetWidth(mainScreenBounds) - 15, 1)] autorelease];
        lineView.backgroundColor = _bottomLine.backgroundColor;
        [_headerView addSubview:lineView];
        
        lineView = [[[UIView alloc] initWithFrame:CGRectMake(15, 0,
                                                                    CGRectGetWidth(mainScreenBounds) - 15, 1)] autorelease];
        lineView.backgroundColor = _bottomLine.backgroundColor;
        [_footerView addSubview:lineView];
        
        _orderTimeLabel = createLabel(CGRectMake(leftMargin, 30, 240, 25),
                               NSTextAlignmentLeft,
                               COMMON_TEXT_COLOR,
                               [UIFont systemFontOfSize:12]);
        [_headerView addSubview:_orderTimeLabel];
        
    }
    return self;
}

- (void)setOrderInfo:(OrderInfo *)info
{
    _orderNo.text = [NSString stringWithFormat:@"订单号：%@", info.no];
    _orderTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@", info.orderedAt];
    
    for (int i=0; i<[info.items count]; i++) {
        OrderItemView* itemView = (OrderItemView *)[_bodyView viewWithTag:100 + i];
        if ( !itemView ) {
            itemView = [[[OrderItemView alloc] init] autorelease];
            [_bodyView addSubview:itemView];
            itemView.tag = 100 + i;
        }
        CGRect frame = itemView.frame;
        frame.origin.y = (CGRectGetHeight(frame) + 5) * i;
        itemView.frame = frame;
        
        [itemView setItem:[info.items objectAtIndex:i]];
    }
    
    _resultLabel.text = [NSString stringWithFormat:@"实付款：%.2f元",info.totalPrice];
    
    CGRect frame = _bodyView.frame;
    frame.origin.y = CGRectGetMaxY(_headerView.frame) + 10;
    frame.size.height = info.items.count * 65 - 5;
    _bodyView.frame = frame;
    
    frame = _footerView.frame;
    frame.origin.y = CGRectGetMaxY(_bodyView.frame) + 10;
    _footerView.frame = frame;
    
    CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 0);
    bounds.size.height = CGRectGetMaxY(_footerView.frame) + 1;
    self.frame = bounds;
    
    frame = _bottomLine.frame;
    frame.origin.y = CGRectGetHeight(self.bounds) - 1;
    _bottomLine.frame = frame;
    
    
    UILabel* stateLabel = (UILabel *)[_footerView viewWithTag:10010];
    if ( !stateLabel ) {
        stateLabel = createLabel(CGRectMake(0, 6, 50, 28), NSTextAlignmentCenter,
                                 [UIColor whiteColor],
                                 [UIFont systemFontOfSize:10]);
        [_footerView addSubview:stateLabel];
        stateLabel.tag = 10010;
        stateLabel.layer.cornerRadius = 3;
        stateLabel.clipsToBounds = YES;
        stateLabel.backgroundColor = RGB(168, 168, 168);
    }
    
    stateLabel.text = info.state;
    
    if ( info.canCancel ) {
        _orderId = info.oid;
        
        UIButton* cancelBtn = (UIButton *)[_footerView viewWithTag:10011];
        if ( !cancelBtn ) {
            cancelBtn = createButton(@"btn_cancel.png", self, @selector(cancelOrder));
            cancelBtn.tag = 10011;
            [_footerView addSubview:cancelBtn];
        }
        
        CGRect frame = cancelBtn.frame;
        frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) - 15 - CGRectGetWidth(frame),
                                   CGRectGetHeight(_footerView.bounds) / 2 - CGRectGetHeight(frame) / 2);
        cancelBtn.frame = frame;
        
        frame = stateLabel.frame;
        frame.origin.x = CGRectGetMinX(cancelBtn.frame) - 5 - CGRectGetWidth(frame);
        stateLabel.frame = frame;
    } else {
        CGRect frame = stateLabel.frame;
        frame.origin.x = CGRectGetWidth(mainScreenBounds) - 15 - CGRectGetWidth(frame);
        stateLabel.frame = frame;
        
        [[_footerView viewWithTag:10011] removeFromSuperview];
    }
    
    if ( [info.stateName isEqualToString:@"no_pay"] ) {
        
        // 保存公钥
        if ( info.publicKey ) {
            [[DataVerifierManager sharedManager] saveAlipayPublicKey:info.publicKey];
        }
        
        CommandButton* payBtn = (CommandButton *)[self viewWithTag:10111];
        if ( !payBtn ) {
            payBtn = [CommandButton buttonWithType:UIButtonTypeCustom];
            [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [payBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            payBtn.backgroundColor = GREEN_COLOR;
            payBtn.frame = CGRectMake(CGRectGetWidth(mainScreenBounds) - 15 - 60, 10, 60, 30);
            payBtn.layer.cornerRadius = 3;
            payBtn.titleLabel.font = [UIFont systemFontOfSize:10.5];
            payBtn.clipsToBounds = YES;
            payBtn.tag = 10111;
            [self addSubview:payBtn];
            
//            self.backgroundColor = [UIColor redColor];
        }
        
//        NSString* description = [info description];
        PayOrderCommand* aCommand = [[[PayOrderCommand alloc] init] autorelease];
        aCommand.userData = info;
        payBtn.command = aCommand;
        
    } else {
        [[self viewWithTag:10111] removeFromSuperview];
    }
}

- (void)btnClicked:(CommandButton*)sender
{
    [sender.command execute];
}

- (void)cancelOrder
{
    [ModalAlert ask:@"你确定吗？" message:nil result:^(BOOL yesOrNo) {
        if ( yesOrNo ) {
            [[DataService sharedService] post:[NSString stringWithFormat:@"/user/orders/%d/cancel", _orderId]
                                       params:@{ @"token" : [[UserService sharedService] token] }
                                   completion:^(NetworkResponse* resp) {
                                       if ( !resp.requestSuccess ) {
                                           [Toast showText:@"呃，系统出错了"];
                                       } else {
                                           if ( resp.statusCode == 0 ) {
                                               [[_footerView viewWithTag:10011] removeFromSuperview];
                                               
                                               UILabel* stateLabel = (UILabel *)[_footerView viewWithTag:10010];
                                               CGRect frame = stateLabel.frame;
                                               frame.origin.x = CGRectGetWidth(mainScreenBounds) - 15 - CGRectGetWidth(frame);
                                               stateLabel.frame = frame;
                                               
                                               stateLabel.text = @"已取消";
                                               
                                               [[self viewWithTag:10111] removeFromSuperview];
                                               
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"kOrderDidCancelNotification" object:nil];
                                               
                                           } else {
                                               [Toast showText:@"操作失败"];
                                           }
                                       }
                                       
                                   }];
        }
    }];

}

@end

@implementation OrderItemView
{
    UIImageView* _iconView;
    UILabel*     _titleLabel;
    UILabel*     _priceDetailLabel;
    LineItem*    _currentItem;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 60);
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 72, 60)];
        [self addSubview:_iconView];
        [_iconView release];
        
        _titleLabel = createLabel(CGRectMake(CGRectGetMaxX(_iconView.frame) + 5,
                                             0,
                                             CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(_iconView.frame) - 20,
                                             37),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont boldSystemFontOfSize:12]);
        [self addSubview:_titleLabel];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _priceDetailLabel = createLabel(CGRectZero, NSTextAlignmentLeft, [UIColor grayColor], [UIFont systemFontOfSize:12]);
        [self addSubview:_priceDetailLabel];
        
        UIButton* btn = createButton(nil, self, @selector(btnClicked));
        btn.frame = self.bounds;
        [self addSubview:btn];
        
    }
    return self;
}

- (void)btnClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kOrderItemDidSelectNotification"
                                                        object:_currentItem];
}

- (void)setItem:(LineItem *)item
{
    [_currentItem release];
    _currentItem = [item retain];
    
    [_iconView setImageWithURL:[NSURL URLWithString:item.itemIconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _titleLabel.text = item.itemTitle;
    [_titleLabel sizeToFit];
    
    _priceDetailLabel.text = [NSString stringWithFormat:@"%.2f × %d", item.price, item.quantity];
    
    CGRect frame = _titleLabel.frame;
    frame.size.height = 23;
    frame.size.width = 200;
    frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(frame) + 3;
    _priceDetailLabel.frame = frame;
}

- (void)dealloc
{
    [_currentItem release];
    [super dealloc];
}

@end
