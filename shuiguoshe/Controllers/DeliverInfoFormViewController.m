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
    UILabel*     _addressLabel;
    int          _apartmentId;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _apartmentId = 0;
    
    self.title = @"新建收货信息";
    
//    [self setLeftBarButtonWithImage:@"btn_close.png"
//                            command:[ForwardCommand buildCommandWithForward:
//                                     [Forward buildForwardWithType:ForwardTypeDismiss
//                                                              from:self toControllerName:nil]]];
    UILabel* mobile = createLabel(CGRectMake(15, 70, 80,
                                             37),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:14]);
    [self.view addSubview:mobile];
    mobile.text = @"收货人手机";
    
    UILabel* address = createLabel(CGRectMake(15, CGRectGetMaxY(mobile.frame), 80,
                                             37),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:14]);
    [self.view addSubview:address];
    address.text = @"收货人地址";
    
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobile.frame) + 5, CGRectGetMinY(mobile.frame), 200, 37)];
    _mobileField.placeholder = @"输入11位手机号";
    _mobileField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_mobileField];
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    
    CGRect frame = address.frame;
    frame.origin.x = CGRectGetMaxX(frame) + 5;
    frame.size.width = CGRectGetWidth(mainScreenBounds) - frame.origin.x - 10;
    _addressLabel = createLabel(frame,
                                NSTextAlignmentLeft,
                                RGB(207, 207, 207),
                                [UIFont systemFontOfSize:14]);
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:_addressLabel];
    
    _addressLabel.text = @"请选择所在小区";
    
    UIButton* save = createButton(nil, self, @selector(save));
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    [save sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:save] autorelease];
    
    ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:
                                [Forward buildForwardWithType:ForwardTypeModal
                                                         from:self
                                             toControllerName:@"ApartmentListViewController"]];
    UIButton* btn = [[CoordinatorController sharedInstance] createCommandButton:nil
                                                                        command:aCommand];
    btn.frame = _addressLabel.frame;
    [self.view addSubview:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelect:)
                                                 name:@"kApartmentDidSelctNotification"
                                               object:nil];
}

- (void)didSelect:(NSNotification *)noti
{
    Apartment* a = noti.object;
    _addressLabel.text = [NSString stringWithFormat:@"%@（%@）",a.name, a.address];
    _addressLabel.textColor = COMMON_TEXT_COLOR;
    
    _apartmentId = a.oid;
}

- (void)save
{
    
    [_mobileField resignFirstResponder];
    
    NSString* mobile = [_mobileField.text stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( [mobile length] == 0 ) {
        [Toast showText:@"手机号必须为非空"];
        return;
    }
    
    NSString *phoneRegex = @"\\A1[3|4|5|8][0-9]\\d{8}\\z";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:mobile];
    if ( !matches ) {
        [Toast showText:@"不正确的手机号"];
        return;
    }
    
    if ( _apartmentId == 0 ) {
        [Toast showText:@"必须选择收货地址"];
        return;
    }
    
    [[DataService sharedService] post:@"/deliver_infos"
                               params:@{ @"token": [[UserService sharedService] token],
                                         @"mobile": mobile,
                                                     @"apartment_id": NSStringFromInteger(_apartmentId)} completion:^(NetworkResponse* resp) {
                                                         
                                                         if ( resp.requestSuccess ) {
                                                             if ( resp.statusCode == 0 ) {
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                             } else {
                                                                 [Toast showText:resp.message];
                                                             }
                                                         } else {
                                                             [Toast showText:@"保存失败"];
                                                         }
                                                         
                                                     }];
}

- (void)dealloc
{
    [super dealloc];
}

@end
