//
//  NewDeliverInfoViewController.m
//  shuiguoshe
//
//  Created by tomwey on 2/27/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import "DeliverInfoFormViewController.h"
#import "Defines.h"

@interface DeliverInfoFormViewController ()

@end

@implementation DeliverInfoFormViewController
{
    UITextField* _mobileField;
    UIButton*    _addressBtn;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"新建收货信息";
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self toControllerName:nil]]];
    UILabel* mobile = createLabel(CGRectMake(15, 70, 80,
                                             37),
                                  NSTextAlignmentLeft,
                                  [UIColor blackColor],
                                  [UIFont systemFontOfSize:14]);
    [self.view addSubview:mobile];
    mobile.text = @"收货人手机";
    
    UILabel* address = createLabel(CGRectMake(15, CGRectGetMaxY(mobile.frame), 80,
                                             37),
                                  NSTextAlignmentLeft,
                                  [UIColor blackColor],
                                  [UIFont systemFontOfSize:14]);
    [self.view addSubview:address];
    address.text = @"收货人地址";
    
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobile.frame) + 5, CGRectGetMinY(mobile.frame), 200, 37)];
    _mobileField.placeholder = @"输入11位手机号";
    [self.view addSubview:_mobileField];
    
    _addressBtn = createButton(nil, self, @selector(showPicker));
    [_addressBtn setTitle:@"请选择所在的小区" forState:UIControlStateNormal];
    _addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addressBtn sizeToFit];
    
    CGRect frame = _addressBtn.frame;
    frame.origin = CGPointMake(CGRectGetMaxX(mobile.frame) + 5, CGRectGetMinY(address.frame));
    _addressBtn.frame = frame;
    
    [self.view addSubview:_addressBtn];
    
    UIButton* save = createButton(nil, self, @selector(save));
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [save sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:save] autorelease];
}

- (void)save
{
    
}

- (void)showPicker
{
    
}

@end
