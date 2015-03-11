//
//  OrderResultViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderResultViewController.h"
#import "Defines.h"

@interface OrderResultViewController ()

@end

@implementation OrderResultViewController

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    if ( [self.userData _paymentType] == PaymentTypeAlipay ) {
        self.title = @"水果社收银台";
    } else {
        self.title = @"订单提交成功";
    }
    
    // 设置左边导航按钮
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypeDismiss
                                                                                                     from:self
                                                                                         toControllerName:nil]]];
    
    
    // 设置右边导航按钮
    
    Forward *aForward = [Forward buildForwardWithType:ForwardTypePush
                                                 from:self toControllerName:@"OrderListViewController"];
    aForward.userData = @"-1";
    
    UIButton* viewBtn = [[CoordinatorController sharedInstance] createTextButton:@"查看订单"
                                                                            font:[UIFont systemFontOfSize:14]
                                                                      titleColor:COMMON_TEXT_COLOR
                                                                         command:[ForwardCommand buildCommandWithForward:aForward]];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:viewBtn] autorelease];
    
    
    // 订单信息容器
    UIView* orderInfoContainer = [[UIView alloc] initWithFrame:CGRectMake(15, 80 - NavigationBarAndStatusBarHeight(),
                                                                          CGRectGetWidth(mainScreenBounds) - 30,
                                                                          168)];
    [self.view addSubview:orderInfoContainer];
    [orderInfoContainer release];
    
    orderInfoContainer.layer.cornerRadius = 6;
    orderInfoContainer.layer.borderColor = [RGB(207, 207, 207) CGColor];
    orderInfoContainer.layer.borderWidth = .4;
    
    orderInfoContainer.clipsToBounds = YES;
    
    // 订单号
    UILabel* orderLabel = createLabel(CGRectMake(10, 20, 80, 30),
                                      NSTextAlignmentRight,
                                      COMMON_TEXT_COLOR,
                                      [UIFont boldSystemFontOfSize:fontSize(14)]);
    orderLabel.text = @"订单号：";
    [orderInfoContainer addSubview:orderLabel];
    
    // 值
    UILabel* orderNoLabel = createLabel(CGRectMake(CGRectGetMaxX(orderLabel.frame), 20, 200, 30),
                                      NSTextAlignmentLeft,
                                      COMMON_TEXT_COLOR,
                                      [UIFont systemFontOfSize:fontSize(14)]);
    orderNoLabel.text = [self.userData no];
    orderNoLabel.adjustsFontSizeToFitWidth = YES;
    [orderInfoContainer addSubview:orderNoLabel];
    
    // 应付金额
    UILabel* totalLabel = createLabel(CGRectMake(10, CGRectGetMaxY(orderLabel.frame), 80, 30),
                                      NSTextAlignmentRight,
                                      COMMON_TEXT_COLOR,
                                      [UIFont boldSystemFontOfSize:fontSize(14)]);
    totalLabel.text = @"应付金额：";
    [orderInfoContainer addSubview:totalLabel];
    
    // 值
    UILabel* totalFeeLabel = createLabel(CGRectMake(CGRectGetMaxX(orderLabel.frame), CGRectGetMinY(totalLabel.frame), 200, 30),
                                        NSTextAlignmentLeft,
                                        COMMON_TEXT_COLOR,
                                        [UIFont systemFontOfSize:fontSize(14)]);
    totalFeeLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.userData totalPrice]];
    [orderInfoContainer addSubview:totalFeeLabel];
    
    // 支付方式
    UILabel* payLabel = createLabel(CGRectMake(10, CGRectGetMaxY(totalLabel.frame), 80, 30),
                                      NSTextAlignmentRight,
                                      COMMON_TEXT_COLOR,
                                      [UIFont boldSystemFontOfSize:fontSize(14)]);
    payLabel.text = @"支付方式：";
    [orderInfoContainer addSubview:payLabel];
    
    UILabel* paymentLabel = createLabel(CGRectMake(CGRectGetMaxX(orderLabel.frame), CGRectGetMinY(payLabel.frame), 200, 30),
                                         NSTextAlignmentLeft,
                                         COMMON_TEXT_COLOR,
                                         [UIFont systemFontOfSize:fontSize(14)]);
    paymentLabel.text = [self.userData _paymentType] == PaymentTypeAlipay ? @"在线支付" : @"货到付款";
    [orderInfoContainer addSubview:paymentLabel];
    
    // 配送
    UILabel* shipmentLabel = createLabel(CGRectMake(10, CGRectGetMaxY(payLabel.frame), 80, 30),
                                      NSTextAlignmentRight,
                                      COMMON_TEXT_COLOR,
                                      [UIFont boldSystemFontOfSize:fontSize(14)]);
    shipmentLabel.text = @"配送时间：";
    [orderInfoContainer addSubview:shipmentLabel];
    
    UILabel* shipmentLabel2 = createLabel(CGRectMake(CGRectGetMaxX(orderLabel.frame), CGRectGetMinY(shipmentLabel.frame), 200, 30),
                                        NSTextAlignmentLeft,
                                        COMMON_TEXT_COLOR,
                                        [UIFont systemFontOfSize:fontSize(14)]);
    shipmentLabel2.text = [self.userData deliveredAt];
    [orderInfoContainer addSubview:shipmentLabel2];
    
    
    if ( [self.userData _paymentType] == PaymentTypeAlipay ) {
        
        // 支付宝支付说明
        UIImageView* iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipay_icon.png"]] autorelease];
        [iconView sizeToFit];
        [self.view addSubview:iconView];
        
        // 支付按钮
        UIButton* payBtn = createButton(@"button_bg.png", self, @selector(payOrder));
        payBtn.center = CGPointMake(CGRectGetMidX(self.view.bounds),
                                    CGRectGetMaxY(orderInfoContainer.frame) + CGRectGetHeight(iconView.frame) + 30 + CGRectGetHeight(payBtn.frame) / 2);
        [self.view addSubview:payBtn];
        
        UILabel* label = createLabel(payBtn.bounds, NSTextAlignmentCenter, [UIColor whiteColor],
                                     [UIFont systemFontOfSize:14]);
        [payBtn addSubview:label];
        label.text = @"立即支付";
        
        // 设置支付宝图标的坐标
        CGRect frame = iconView.frame;
        frame.origin = CGPointMake(CGRectGetMinX(payBtn.frame), CGRectGetMaxY(orderInfoContainer.frame) + 20);
        iconView.frame = frame;
        
        // 支付宝提示
        UILabel* label1 = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5,
                                                 CGRectGetMinY(iconView.frame) - 8,
                                                 CGRectGetWidth(payBtn.frame) - CGRectGetWidth(iconView.frame) - 5,
                                                 30),
                                      NSTextAlignmentLeft,
                                      COMMON_TEXT_COLOR,
                                      [UIFont boldSystemFontOfSize:fontSize(14)]);
        label1.text = @"支付宝钱包支付";
        [self.view addSubview:label1];
        
        UILabel* label2 = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5,
                                                 CGRectGetMaxY(label1.frame) - 8,
                                                 CGRectGetWidth(payBtn.frame) - CGRectGetWidth(iconView.frame) - 5,
                                                 30),
                                      NSTextAlignmentLeft,
                                      RGB(207, 207, 207),
                                      [UIFont systemFontOfSize:fontSize(13)]);
        label2.text = @"推荐支付宝用户使用";
        [self.view addSubview:label2];
    }

}

- (void)payOrder
{
    NSString* description = [self.userData description];
#if DEBUG
    NSLog(@"order description: %@", description);
#endif
    
    id<DataSigner> signer = CreateRSADataSigner([self.userData privateKey]);
    NSString *signedString = [signer signString:description];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       description, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipay-shuiguoshe" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
}

@end
