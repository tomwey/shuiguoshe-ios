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
    UITextField* _nameField;
    UITextField* _mobileField;
    UITextField* _addressField;
    UILabel*     _addressLabel;
    int          _apartmentId;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _apartmentId = 0;
    
    self.title = @"新建收货信息";
    
    UILabel* name = createLabel(CGRectMake(15, 80 - NavigationBarAndStatusBarHeight(), 80,
                                             30),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:16]);
    [self.view addSubview:name];
    name.text = @"收货人姓名";
    
    UILabel* mobile = createLabel(CGRectMake(15, CGRectGetMaxY(name.frame) + 5, 80,
                                             30),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:16]);
    [self.view addSubview:mobile];
    mobile.text = @"收货人手机";
    
    UILabel* address = createLabel(CGRectMake(15, CGRectGetMaxY(mobile.frame) + 5, 80,
                                             30),
                                  NSTextAlignmentLeft,
                                  COMMON_TEXT_COLOR,
                                  [UIFont systemFontOfSize:16]);
    [self.view addSubview:address];
    address.text = @"收货人地址";
    
    // 收货人姓名
    _nameField = [[UITextField alloc] initWithFrame:
                  CGRectMake(CGRectGetMaxX(name.frame) + 5,
                             CGRectGetMinY(name.frame),
                             CGRectGetWidth(mainScreenBounds) - 15 * 2 - 85, 30)];
    _nameField.placeholder = @"输入收货人姓名";
    _nameField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_nameField];
    [_nameField release];
    
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    // 手机号
    _mobileField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobile.frame) + 5, CGRectGetMinY(mobile.frame),
                                                                 CGRectGetWidth(_nameField.frame), 30)];
    _mobileField.placeholder = @"输入11位手机号";
    _mobileField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_mobileField];
    [_mobileField release];
    _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    
    _mobileField.borderStyle = UITextBorderStyleRoundedRect;
    
    // 收货地址
    CGRect frame = address.frame;
    frame.origin.x = CGRectGetMaxX(frame) + 5;
    frame.size.width = CGRectGetWidth(_nameField.frame);
    _addressLabel = createLabel(frame,
                                NSTextAlignmentLeft,
                                RGB(207, 207, 207),
                                [UIFont systemFontOfSize:16]);
    _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:_addressLabel];
    
    _addressLabel.text = [[[DataService sharedService] areaForLocal] name];//@"请选择所在小区或大学";
    
    frame = _addressLabel.frame;
    frame.origin.y = CGRectGetMaxY(frame);
    UITextField* addressField = [[UITextField alloc] initWithFrame:frame];
    [self.view addSubview:addressField];
    [addressField release];
    
    addressField.font = [UIFont systemFontOfSize:16];
    
    addressField.placeholder = @"详细地址（可不填）";
    
    addressField.borderStyle = UITextBorderStyleRoundedRect;
    
    _addressField = addressField;
    
    // 保存按钮
    UIButton* newBtn = createButton2(@"button_bg3.png", @"保存", self, @selector(save));
    [newBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    CGRect frame2 = newBtn.frame;
    frame2.size.width = 52;
    newBtn.frame = frame2;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:newBtn] autorelease];
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
    [_nameField resignFirstResponder];
    [_addressField resignFirstResponder];
    
    NSString* name = !!_nameField.text ? [_nameField.text stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
    if ( [name length] == 0 ) {
        [Toast showText:@"收货人姓名必须为非空"];
        return;
    }
    
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
    
    NSString* address = !!_addressField.text ? [_addressField.text stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
    
    [[DataService sharedService] post:@"/deliver_infos"
                               params:@{ @"token": [[UserService sharedService] token],
                                         @"name": name,
                                         @"mobile": mobile,
                                         @"area_id": NSStringFromInteger([[[DataService sharedService] areaForLocal] oid]),
                                         @"address": address,
                                        }
                            completion:^(NetworkResponse* resp) {
                                                         
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
