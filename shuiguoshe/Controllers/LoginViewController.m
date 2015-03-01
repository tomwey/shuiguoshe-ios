//
//  LoginViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation LoginViewController
{
    NSArray*     _dataSource;
    UITableView* _tableView;
    User*        _currentUser;
    
    UITextField* _mobileField;
    UITextField* _passwordField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self
                                                      toController:nil]]];
    
    _currentUser = [[User alloc] init];
    
    FormItem* uf1 = [[[FormItem alloc] init] autorelease];
    uf1.name = @"name";
    uf1.label = @"手机号码";
    uf1.placeholder = @"请输入您的手机号";
    
    FormItem* uf2 = [[[FormItem alloc] init] autorelease];
    uf2.name = @"password";
    uf2.label = @"登录密码";
    uf2.placeholder = @"请输入您的密码";
    
    _dataSource = [[NSArray alloc] initWithObjects:uf1, uf2, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44;
    
    UIView* footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 300)] autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    
    // 登录按钮
    UIButton* cmdBtn = createButton(@"btn_login.png", self, @selector(doLogin));
    
    [footerView addSubview:cmdBtn];
    
    CGRect frame = cmdBtn.frame;
    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) / 2 - CGRectGetWidth(frame) / 2, 20);
    cmdBtn.frame = frame;
    
    Command* aCommand = nil;
    
    // 注册按钮
    aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                from:self
                                                                    toControllerName:@"RegisterViewController"]];
    
    CommandButton* regBtn = [[CoordinatorController sharedInstance] createTextButton:@"注册账号"
                                                                                font:[UIFont boldSystemFontOfSize:16]
                                                                          titleColor:GREEN_COLOR
                                                                             command:aCommand];
    [footerView addSubview:regBtn];
    
    frame = regBtn.frame;
    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) / 2 - 10 - CGRectGetWidth(frame),
                               CGRectGetMaxY(cmdBtn.frame) + 20);
    regBtn.frame = frame;
    
    // 线
    UILabel* lineLabel = createLabel(CGRectZero,
                                     NSTextAlignmentCenter,
                                     RGB(137, 137, 137),
                                     [UIFont boldSystemFontOfSize:16]);
    lineLabel.frame = CGRectMake(0, 0, 10, 30);
    lineLabel.text = @"|";
    lineLabel.center = CGPointMake(CGRectGetWidth(mainScreenBounds) / 2, CGRectGetMinY(regBtn.frame) + CGRectGetHeight(lineLabel.bounds)/2);
    [footerView addSubview:lineLabel];
    
    // 忘记密码
    aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                from:self
                                                                    toControllerName:@"ForgetPasswordViewController"]];
    CommandButton* forgetBtn = [[CoordinatorController sharedInstance] createTextButton:@"忘记密码"
                                                                                font:[UIFont boldSystemFontOfSize:16]
                                                                          titleColor:GREEN_COLOR
                                                                             command:aCommand];
    [footerView addSubview:forgetBtn];
    
    frame = forgetBtn.frame;
    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) / 2 + 10,
                               CGRectGetMaxY(cmdBtn.frame) + 20);
    forgetBtn.frame = frame;
}

- (void)doLogin
{
    
    // 手机号检查
    if ( _mobileField.text.length == 0 ) {
        [Toast showText:@"手机号不能为空"];
        return;
    }
    
    NSString *phoneRegex = @"\\A1[3|4|5|8][0-9]\\d{8}\\z";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:_mobileField.text];
    
    if ( !matches ) {
        [Toast showText:@"手机号不正确"];
        return;
    }
    
    // 密码检查
    if ( _passwordField.text.length < 6 ) {
        [Toast showText:@"密码至少为6位"];
        return;
    }
    
    [self hideKeyboard];
        
    __block LoginViewController* me = self;
    [[UserService sharedService] login:_currentUser completion:^(BOOL succeed, NSString* errorMsg) {
        if ( succeed ) {
            [me dismissViewControllerAnimated:YES completion:nil];
        } else {
            [Toast showText:errorMsg];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell:%d", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel* label = (UILabel *)[cell.contentView viewWithTag:100];
    if ( !label ) {
        label = createLabel(CGRectMake(15, (tableView.rowHeight - 30) / 2, 100, 30),
                            NSTextAlignmentLeft,
                            RGB(131, 131, 131),
                            [UIFont boldSystemFontOfSize:16]);
        [cell.contentView addSubview:label];
        label.tag = 100;
    }
    
    FormItem* uf = [_dataSource objectAtIndex:indexPath.row];
    label.text = uf.label;
    
    InputTextField* tf = (InputTextField *)[cell.contentView viewWithTag:101];
    if ( !tf ) {
        tf = [[InputTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),
                                                           0, 200, 44)];
        tf.tag = 101;
        [cell.contentView addSubview:tf];
        [tf release];
        
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.delegate = self;
    }
    
    tf.placeholder = uf.placeholder;
    tf.name = uf.name;
    
    if ( [tf.name isEqualToString:@"name"] ) {
        _mobileField = tf;
    } else if ( [tf.name isEqualToString:@"password"] ) {
        _passwordField = tf;
    }
    
    if ( indexPath.row == 0 ) {
        tf.keyboardType = UIKeyboardTypeNumberPad;
    } else if ( indexPath.row == 1 ) {
        tf.returnKeyType = UIReturnKeyDone;
        tf.secureTextEntry = YES;
    }
    
    return cell;
}

#pragma mark - UITextField delegate
- (BOOL)shouldShowingCart
{
    return NO;
}

- (void)textFieldDidEndEditing:(InputTextField *)textField
{
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [textField.name capitalizedString]]);
    if ( [_currentUser respondsToSelector:setter] ) {
        [_currentUser performSelector:setter withObject:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doLogin];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    for ( UITableViewCell* cell in [_tableView visibleCells] ) {
        [[cell.contentView viewWithTag:101] resignFirstResponder];
    }
}

- (void)dealloc
{
    [_currentUser release];
    [_dataSource release];
    [super dealloc];
}

@end
