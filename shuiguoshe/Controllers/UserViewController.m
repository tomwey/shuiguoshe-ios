//
//  UserViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UserViewController

- (BOOL)shouldShowingCart
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    if ( [tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
        tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ( [tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
        tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }

    // 关闭按钮
    UIButton* backBtn = createButton(@"btn_close", self, @selector(back));
    [tableView addSubview:backBtn];
    backBtn.center = CGPointMake(20 + CGRectGetWidth(backBtn.bounds) / 2, 42 - tableView.contentInset.top);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

static int rows[] = { 2, 3, 3 };
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"s:%ld,r:%ld", indexPath.section, indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] ) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        if ( indexPath.section == 0 && indexPath.row == 0 ) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    switch (indexPath.section) {
        case 0:
            [self addContentForSectionOne:cell indexPath:indexPath];
            break;
        case 1:
            [self addContentForSectionTwo:cell indexPath:indexPath];
            break;
        case 2:
            [self addContentForSectionThree:cell indexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)addContentForSectionOne:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 0 ) {
        // 设置用户信息
        UserProfileView* upv = (UserProfileView *)[cell.contentView viewWithTag:99];
        if ( !upv ) {
            upv = [[[UserProfileView alloc] init] autorelease];
            upv.tag = 99;
            [cell.contentView addSubview:upv];
            
            upv.imagePickerContainer = self;
        }
        
        User* u = [[UserService sharedService] loadUser];
        [upv setUser:u];
        
        // 订单
        CGFloat width = CGRectGetWidth(mainScreenBounds) / 3;
        for (int i=0; i<3; i++) {
            int tag = 100 + i;
            
            OrderStateView* osv = (OrderStateView *)[cell.contentView viewWithTag:tag];
            if ( !osv ) {
                osv = [[OrderStateView alloc] init];
                osv.tag = tag;
                [cell.contentView addSubview:osv];
                [osv release];
            }
            
            if ( i == 2 ) {
                osv.shouldShowingRightLine = NO;
            }
            
            osv.frame = CGRectMake(width * i, CGRectGetMaxY(upv.frame) + 5, width, 100);
            
            [osv setOrderState:[[self loadOrderStates:u] objectAtIndex:i]];
        }

    } else {
        cell.textLabel.text = @"全部订单";
    }
}

- (NSArray *)loadOrderStates:(User *)u
{
    OrderState* os1 = [OrderState stateWithName:@"带配送" quantity:u.deliveringCount stateType:OrderStateTypeDelivering];
    
    OrderState* os2 = [OrderState stateWithName:@"已完成" quantity:u.deliveringCount stateType:OrderStateTypeDone];
    
    OrderState* os3 = [OrderState stateWithName:@"已取消" quantity:u.deliveringCount stateType:OrderStateTypeCanceled];
    
    return @[os1, os2, os3];
}

static NSString* label1s[] = { @"我的积分", @"我的收藏", @"有话要说" };
- (void)addContentForSectionTwo:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = label1s[indexPath.row];
}

static NSString* label2s[] = { @"收货地址设置", @"修改密码", @"退出登录" };
- (void)addContentForSectionThree:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = label2s[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section > 0 ) {
        return 44;
    }
    
    if ( indexPath.row == 0 ) {
        return 251 + 110;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            if ( indexPath.row == 2 ) {
                
                [ModalAlert showWithTitle:@"确定退出登录吗？"
                                  message:nil
                             cancelButton:nil
                             otherButtons:@[@"确定", @"取消"]
                                   result:^(NSUInteger buttonIndex) {
                                       if ( buttonIndex == 0 ) {
                                           [[UserService sharedService] logout:^(BOOL succeed, NSString *errorMsg) {
                                               if ( succeed ) {
                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                               } else {
                                                   [self.view makeToast:errorMsg];
                                               }
                                           }];
                                       }
                                   }];
                
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
