//
//  UpdatePasswordViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "Defines.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController
{
    UITextField* _oldTextField;
    UITextField* _newTextField;
    UITextField* _confirmTextField;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    UIButton* btn = [[CoordinatorController sharedInstance] createTextButton:@"保存"
                                                                        font:[UIFont systemFontOfSize:14] titleColor:COMMON_TEXT_COLOR command:nil];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    [btn addTarget:self
            action:@selector(save)
  forControlEvents:UIControlEventTouchUpInside];
    
    
    // 旧密码
    UILabel* oldPassword = createLabel(CGRectMake(15, 80, 80, 30),
                                       NSTextAlignmentRight,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:16]);
    [self.view addSubview:oldPassword];
    oldPassword.text = @"旧密码";
    
    _oldTextField = [[UITextField alloc] initWithFrame:
                     CGRectMake(CGRectGetMaxX(oldPassword.frame) + 10,
                     CGRectGetMinY(oldPassword.frame),
                     CGRectGetWidth(mainScreenBounds) - 15 * 2 - 80 - 10, 30)];
    [self.view addSubview:_oldTextField];
    [_oldTextField release];
    
    _oldTextField.font = [UIFont systemFontOfSize:16];
    
    _oldTextField.placeholder = @"输入旧密码";
    
//    _oldTextField.layer.borderWidth = .5;
//    _oldTextField.layer.borderColor = [RGB(207, 207, 207) CGColor];
//    _oldTextField.layer.cornerRadius = 2;
    
    _oldTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    // 新密码
    UILabel* newPassword = createLabel(CGRectMake(15, CGRectGetMaxY(oldPassword.frame) + 5,
                                                  80, 30),
                                       NSTextAlignmentRight,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:16]);
    [self.view addSubview:newPassword];
    newPassword.text = @"新密码";
    
    _newTextField = [[UITextField alloc] initWithFrame:
                     CGRectMake(CGRectGetMaxX(oldPassword.frame) + 10, CGRectGetMinY(newPassword.frame),
                         CGRectGetWidth(_oldTextField.frame), 30)];
    [self.view addSubview:_newTextField];
    [_newTextField release];
    _newTextField.font = [UIFont systemFontOfSize:16];
    
    _newTextField.placeholder = @"输入新密码";
    
//    _newTextField.layer.borderWidth = .5;
//    _newTextField.layer.borderColor = [RGB(207, 207, 207) CGColor];
//    _newTextField.layer.cornerRadius = 2;
    
    _newTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    // 确认新密码
    UILabel* confirmPassword = createLabel(CGRectMake(15, CGRectGetMaxY(newPassword.frame) + 5, 80, 30),
                                       NSTextAlignmentRight,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:16]);
    [self.view addSubview:confirmPassword];
    confirmPassword.text = @"确认新密码";
    
    _confirmTextField = [[UITextField alloc] initWithFrame:
                         CGRectMake(CGRectGetMaxX(oldPassword.frame) + 10,
                        CGRectGetMinY(confirmPassword.frame),
                                    CGRectGetWidth(_oldTextField.frame), 30)];
    [self.view addSubview:_confirmTextField];
    [_confirmTextField release];
    
//    _confirmTextField.layer.borderWidth = .5;
//    _confirmTextField.layer.borderColor = [RGB(207, 207, 207) CGColor];
//    _newTextField.layer.cornerRadius = 2;
    _confirmTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    _confirmTextField.placeholder = @"确认新密码";
    
    _oldTextField.clearButtonMode =
    _newTextField.clearButtonMode =
    _confirmTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _oldTextField.secureTextEntry =
    _newTextField.secureTextEntry =
    _confirmTextField.secureTextEntry = YES;
}

- (void)save
{
    NSString* oldPassword = [_oldTextField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( oldPassword.length == 0 ) {
        [Toast showText:@"旧密码必须为非空"];
        return;
    }
    
    NSString* newPassword = [_newTextField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( newPassword.length == 0 ) {
        [Toast showText:@"新密码必须为非空"];
        return;
    }
    
    NSString* confirmPassword = [_confirmTextField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( confirmPassword.length == 0 ) {
        [Toast showText:@"确认密码必须为非空"];
        return;
    }
    
    if ( newPassword.length < 6 ||
        confirmPassword.length < 6 ) {
        [Toast showText:@"密码至少为6位"];
        return;
    }
    
    if ( ![newPassword isEqualToString:confirmPassword] ) {
        [Toast showText:@"新密码与确认密码不一致"];
        return;
    }
    
    // 加密密码
    oldPassword = [[oldPassword dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    newPassword = [[newPassword dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    
    [[DataService sharedService] post:@"/account/password/update"
                               params:@{ @"token":[[UserService sharedService] token],
                                         @"old_password": oldPassword,
                                         @"password": newPassword}
                           completion:^(NetworkResponse* resp) {
                               if ( resp.requestSuccess ) {
                                   if ( resp.statusCode == 0 ) {
                                       [Toast showText:@"密码修改成功"];
                                   } else {
                                       [Toast showText:resp.message];
                                   }
                               } else {
                                   [Toast showText:@"呃，系统出错了"];
                               }
                           }];
}

@end
