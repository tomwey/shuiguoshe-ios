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
    
    self.title = @"提交订单成功";
    
    [self setLeftBarButtonWithImage:@"btn_back.png"
                            command:[ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePopTo
                                                                                                     from:self
                                                                                         toControllerName:@"CartViewController"]]];
    
    
    // 订单提交成功
    UILabel* resultLabel = createLabel(CGRectMake(15, 80, 200, 50),
                                       NSTextAlignmentLeft,
                                       GREEN_COLOR,
                                       [UIFont boldSystemFontOfSize:24]);
    [self.view addSubview:resultLabel];
    resultLabel.text = @"订单提交成功！";
    
    // 订单号
    UILabel* orderNo = createLabel(CGRectMake(CGRectGetMinX(resultLabel.frame),
                                              CGRectGetMaxY(resultLabel.frame),
                                              240, 30),
                                   NSTextAlignmentLeft,
                                   [UIColor blackColor],
                                   [UIFont systemFontOfSize:14]);
    [self.view addSubview:orderNo];
    
    orderNo.text = [NSString stringWithFormat:@"订单号：%@", [self.userData no]];
    
    // 应付金额
    UILabel* priceLabel = createLabel(CGRectMake(CGRectGetMinX(resultLabel.frame),
                                              CGRectGetMaxY(orderNo.frame),
                                              200, 30),
                                   NSTextAlignmentLeft,
                                   [UIColor blackColor],
                                   [UIFont systemFontOfSize:14]);
    [self.view addSubview:priceLabel];
    
    priceLabel.text = [NSString stringWithFormat:@"应付金额：%.2f元", [self.userData totalPrice]];
    
    // 配送
    UILabel* deliverLabel = createLabel(CGRectMake(CGRectGetMinX(resultLabel.frame),
                                                 CGRectGetMaxY(priceLabel.frame),
                                                 280, 30),
                                      NSTextAlignmentLeft,
                                      [UIColor blackColor],
                                      [UIFont systemFontOfSize:14]);
    [self.view addSubview:deliverLabel];
    
    deliverLabel.text = [NSString stringWithFormat:@"配送：%@",[self.userData deliveredAt]];
    
//    CGFloat width = (CGRectGetWidth(mainScreenBounds) - 3 * CGRectGetMinX(resultLabel.frame)) / 2.0;
//    
//    // 回首页
//    UIButton* homeBtn = createButton(nil, self, @selector(goHome));
//    [homeBtn setTitle:@"回首页" forState:UIControlStateNormal];
//    homeBtn.backgroundColor = GREEN_COLOR;
//    
//    homeBtn.layer.cornerRadius = 5;
//    homeBtn.clipsToBounds = YES;
//    
//    homeBtn.frame = CGRectMake(CGRectGetMinX(resultLabel.frame), CGRectGetMaxY(deliverLabel.frame) + 5,
//                               width, 37);
//    [self.view addSubview:homeBtn];
//    
    // 查看订单
//    UIButton* viewBtn = createButton(nil, self, @selector(viewOrder));
//    [viewBtn setTitle:@"查看订单" forState:UIControlStateNormal];
//    viewBtn.backgroundColor = GREEN_COLOR;
//    
//    viewBtn.layer.cornerRadius = 5;
//    viewBtn.clipsToBounds = YES;
//    
//    viewBtn.frame = CGRectMake(CGRectGetMinX(resultLabel.frame),
//                               CGRectGetMaxY(deliverLabel.frame) + 5,
//                               CGRectGetWidth(mainScreenBounds) - 2 * CGRectGetMinX(resultLabel.frame), 37);
//    [self.view addSubview:viewBtn];
    
    Forward *aForward = [Forward buildForwardWithType:ForwardTypePush
                                                 from:self toControllerName:@"OrderListViewController"];
    aForward.userData = @"1";
    
    UIButton* viewBtn = [[CoordinatorController sharedInstance] createTextButton:@"查看订单"
                                                                            font:[UIFont systemFontOfSize:14]
                                                                      titleColor:[UIColor blackColor]
                                                                         command:[ForwardCommand buildCommandWithForward:aForward]];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:viewBtn] autorelease];
}

- (void)viewOrder
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
