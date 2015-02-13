//
//  ForgetPasswordViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Defines.h"

@interface ForgetPasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation ForgetPasswordViewController
{
    NSArray*     _dataSource;
    UITableView* _tableView;
    User*        _currentUser;
    
    UIButton*    _regBtn;
    
    CGPoint      _tableOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    _currentUser = [[User alloc] init];
    
    FormItem* uf1 = [[[FormItem alloc] init] autorelease];
    uf1.name = @"name";
    uf1.label = @"手机号码";
    uf1.placeholder = @"请输入您的手机号";
    
    FormItem* uf2 = [[[FormItem alloc] init] autorelease];
    uf2.name = @"password";
    uf2.label = @"新密码";
    uf2.placeholder = @"请输入至少6位密码";
    
    FormItem* uf3 = [[[FormItem alloc] init] autorelease];
    uf3.name = @"code";
    uf3.label = @"验证码";
    uf3.placeholder = @"请输入短信验证码";
    
    _dataSource = [[NSArray alloc] initWithObjects:uf1, uf2, uf3, nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44;
    
    UIView* footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 300)] autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = footerView;
    
    // 注册按钮
    _regBtn = createButton(@"btn_submit.png", self, @selector(doSubmit));
    
    [footerView addSubview:_regBtn];
    
    CGRect frame = _regBtn.frame;
    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) / 2 - CGRectGetWidth(frame) / 2, 20);
    _regBtn.frame = frame;
    
    _tableOffset = CGPointMake(0, -64);
}

- (void)doSubmit
{
    [self hideKeyboard];
    
    if ( ![_currentUser checkValue] ) {
        NSArray* errors = [_currentUser errors];
        
        NSMutableString* error = [NSMutableString string];
        for (id dict in errors) {
            [error appendString:[[dict allValues] lastObject]];
            [error appendString:@"\n"];
        }
        [error deleteCharactersInRange:NSMakeRange(error.length - 2, 1)];
        
        [self.view makeToast:error duration:1.0 position:CSToastPositionBottom];
        return;
    }
    
    __block ForgetPasswordViewController* me = self;
    [[UserService sharedService] forgetPassword:_currentUser completion:^(BOOL succeed, NSString* errorMsg) {
        if ( succeed ) {
            [me.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [me.view makeToast:errorMsg];
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
        tf.font = [UIFont systemFontOfSize:14];
    }
    
    if ( indexPath.row == 2 ) {
        UIButton* codeBtn = (UIButton *)[cell.contentView viewWithTag:105];
        if ( !codeBtn ) {
            codeBtn = createButton(@"btn_code.png", self, @selector(fetchCode:));
            CGRect frame = codeBtn.frame;
            frame.origin = CGPointMake(mainScreenBounds.size.width - 10 - CGRectGetWidth(frame),
                                       44 / 2 - CGRectGetHeight(frame) / 2);
            codeBtn.frame = frame;
            [cell.contentView addSubview:codeBtn];
            codeBtn.tag = 105;
        }
        
        tf.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 120, 44);
    }
    
    tf.placeholder = uf.placeholder;
    tf.name = uf.name;
    
    if ( indexPath.row == 0 || indexPath.row == 2 ) {
        tf.keyboardType = UIKeyboardTypeNumberPad;
    } else if ( indexPath.row == 1 ) {
        tf.returnKeyType = UIReturnKeyDone;
        tf.secureTextEntry = YES;
    }
    
    return cell;
}

- (void)fetchCode:(UIButton *)sender
{
    [self hideKeyboard];
    
    if ( ![_currentUser checkMobile] ) {
        NSArray* errors = [_currentUser errors];
        
        NSMutableString* error = [NSMutableString string];
        for (id dict in errors) {
            [error appendString:[[dict allValues] lastObject]];
            [error appendString:@"\n"];
        }
        [error deleteCharactersInRange:NSMakeRange(error.length - 2, 1)];
        
        [self.view makeToast:error duration:1.0 position:CSToastPositionCenter];
        
        return;
    }
    
    sender.enabled = NO;
    _currentUser.codeType = @"2";
    [[UserService sharedService] fetchCode:_currentUser completion:^(BOOL succeed, NSString *errorMsg) {
        sender.enabled = YES;
        if ( !succeed ) {
            [self.view makeToast:errorMsg];
        } else {
            [self.view makeToast:@"短信验证码已发出"];
        }
    }];
}

#pragma mark - UITextField delegate
- (BOOL)shouldShowingCart
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(InputTextField *)textField
{
    if ( [textField.name isEqualToString:@"code"] ) {
        [UIView animateWithDuration:.35
                         animations:^{
                             CGPoint offset = _tableOffset;
                             offset.y += 50;
                             _tableView.contentOffset = offset;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(InputTextField *)textField
{
    SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [textField.name capitalizedString]]);
    if ( [_currentUser respondsToSelector:setter] ) {
        [_currentUser performSelector:setter withObject:textField.text];
    }
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
