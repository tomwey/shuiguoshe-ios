//
//  UserViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) User *currentUser;

@end

@implementation UserViewController
{
    UITableView* _tableView;
}

- (BOOL)shouldShowingCart
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] ) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    if ( [_tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ( [_tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        _tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    }

    // 关闭按钮
    UIButton* backBtn = createButton(@"btn_close", self, @selector(back));
    [_tableView addSubview:backBtn];
    backBtn.center = CGPointMake(20 + CGRectGetWidth(backBtn.bounds) / 2, 42 - _tableView.contentInset.top);
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"kOrderDidCancelNotification"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loadData)
//                                                 name:@"kOrderFinishedPaymentNotification"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateInfo:)
                                                 name:@"kUpdateDeliverInfoSuccessNotification"
                                               object:nil];
    
}

- (void)updateInfo:(NSNotification *)noti
{
    DeliverInfo* di = noti.object;
    self.currentUser.currentDeliverInfoId = di.infoId;
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
        
        [upv setUser:self.currentUser];
        
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
            
            [osv setOrderState:[[self loadOrderStates:self.currentUser] objectAtIndex:i]];
            
            __block UserViewController* me = self;
            osv.didSelectBlock = ^(OrderState *state) {
                Forward *aForward = [Forward buildForwardWithType:ForwardTypePush
                                                             from:me
                                                 toControllerName:@"OrderListViewController"];
                aForward.userData = NSStringFromInteger(state.stateType);
                ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
                [aCommand execute];
            };
        }

    } else {
        cell.textLabel.text = @"全部订单";
    }
}

- (NSArray *)loadOrderStates:(User *)u
{
    OrderState* os1 = [OrderState stateWithName:@"待付款" quantity:u.noPayCount stateType:OrderStateTypeNoPay];
    
    OrderState* os2 = [OrderState stateWithName:@"待配送" quantity:u.deliveringCount stateType:OrderStateTypeDelivering];
    
    OrderState* os3 = [OrderState stateWithName:@"已取消" quantity:u.canceledCount stateType:OrderStateTypeCanceled];
    
    return @[os1, os2, os3];
}

static NSString* label1s[] = { @"我的积分", @"我的收藏", @"有话要说" };
- (void)addContentForSectionTwo:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = label1s[indexPath.row];
}

static NSString* label2s[] = { @"收货信息管理", @"修改密码", @"退出登录" };
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
        return 251 * CGRectGetWidth(mainScreenBounds) / 320.0 + 110;
    }
    
    return 44;
}

static NSString* controllers[] = {@"ScoreListViewController", @"LikeListViewController", @"NewMessageViewController"};
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            if ( indexPath.row == 1 ) {
                Forward *aForward = [Forward buildForwardWithType:ForwardTypePush
                                                             from:self
                                                 toControllerName:@"OrderListViewController"];
                aForward.userData = @"-1";
                ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
                [aCommand execute];
            }
        }
            break;
        case 1:
        {
            Forward *aForward = [Forward buildForwardWithType:ForwardTypePush
                                                         from:self
                                             toControllerName:controllers[indexPath.row]];
            ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
            [aCommand execute];
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
                                                   [Toast showText:errorMsg];
                                               }
                                           }];
                                       }
                                   }];
                
            } else if ( indexPath.row == 0 ) {
                ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush from:self toControllerName:@"DeliverInfoListViewController"]];
                
                DeliverInfo* info = [[[DeliverInfo alloc] init] autorelease];
                info.infoId = self.currentUser.currentDeliverInfoId;
                
                aCommand.userData = info;
                
                [aCommand execute];
            } else if ( indexPath.row == 1 ) {
                ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush from:self toControllerName:@"UpdatePasswordViewController"]];
                [aCommand execute];
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

- (void)loadData
{
    [[DataService sharedService] loadEntityForClass:@"User"
                                                URI:[NSString stringWithFormat:@"/user/me?token=%@&area_id=%d",
                                                     [[UserService sharedService] token],
                                                     [[[DataService sharedService] areaForLocal] oid]]
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 self.currentUser = result;
                                                 _tableView.hidden = NO;
                                                 [_tableView reloadData];
                                             } else {
                                                 //                                                 [Toast showText:@"登录失败"];
                                                 //                                                 _tableView.hidden = YES;
                                             }
                                             
                                         }];
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
