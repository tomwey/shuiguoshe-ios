//
//  DeliverInfoListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-27.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "DeliverInfoListViewController.h"
#import "Defines.h"

@interface DeliverInfoListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DeliverInfoListViewController
{
    NSMutableArray* _dataSource;
    UITableView*    _tableView;
}

- (BOOL) shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货地址";
    
    [self setRightBarButtonWithImage:@"btn_incr.png"
                             command:[ForwardCommand buildCommandWithForward:
                                      [Forward buildForwardWithType:ForwardTypePush from:self
                                                   toControllerName:@"DeliverInfoFormViewController"]]];
    
    CGRect frame = self.view.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _dataSource = [[NSMutableArray alloc] init];
    
    UIView* footer = [[[UIView alloc] init] autorelease];
    _tableView.tableFooterView = footer;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_dataSource removeAllObjects];
    
    [[DataService sharedService] loadEntityForClass:@"DeliverInfo"
                                                URI:[NSString stringWithFormat:@"/deliver_infos?token=%@", [[UserService sharedService] token]]
                                         completion:^(id result, BOOL succeed)
     {
         [_dataSource addObjectsFromArray:result];
         [_tableView reloadData];
     }];
    
}

- (void)dealloc
{
    [_dataSource release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell-%d", indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId] autorelease];
    }
    
    UILabel* mobile = (UILabel *)[cell.contentView viewWithTag:100];
    if ( !mobile ) {
        mobile = createLabel(CGRectMake(15, 5, 100, 37),
                             NSTextAlignmentLeft,
                             COMMON_TEXT_COLOR,
                             [UIFont systemFontOfSize:14]);
        mobile.tag = 100;
        [cell.contentView addSubview:mobile];
    }
    
    
    DeliverInfo* di = [_dataSource objectAtIndex:indexPath.row];
    
    UIButton* btn = (UIButton *)[cell.contentView viewWithTag:1000 + indexPath.row];
    if ( !btn ) {
        btn = createButton(nil, self, @selector(delete:));
        btn.tag = 1000 + indexPath.row;
        [cell.contentView addSubview:btn];
        btn.backgroundColor = RGB(201, 62, 59);
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.frame = CGRectMake(CGRectGetWidth(mainScreenBounds) - 15 - 60 - 30,
                               CGRectGetMinY(mobile.frame),
                               50, 34);
        btn.layer.cornerRadius = 3;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.clipsToBounds = YES;
    }
    
    mobile.text = [di.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    // 地址
    UILabel* address = (UILabel *)[cell.contentView viewWithTag:101];
    if ( !address ) {
        address = createLabel(CGRectMake(15, CGRectGetMaxY(mobile.frame), CGRectGetWidth(mainScreenBounds) - 50, 37),
                             NSTextAlignmentLeft,
                             [UIColor grayColor],
                             [UIFont systemFontOfSize:14]);
        address.tag = 101;
        [cell.contentView addSubview:address];
        address.numberOfLines = 0;
        address.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    address.text = di.address;
    CGSize size = [address.text sizeWithFont:address.font
                           constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - 50,
                                                        1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = address.frame;
    frame.size.height = size.height;
    address.frame = frame;
    
    if ( di.infoId == [self.userData infoId] ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliverInfo* di = [_dataSource objectAtIndex:indexPath.row];
    
    CGSize size = [di.address sizeWithFont:[UIFont systemFontOfSize:14]
                           constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - 50,
                                                        1000) lineBreakMode:NSLineBreakByWordWrapping];
    return 37 + size.height + 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeliverInfo* di = [_dataSource objectAtIndex:indexPath.row];
    
    [[DataService sharedService] post:@"/user/update_deliver_info"
                               params:@{ @"token": [[UserService sharedService] token],
                                         @"deliver_info_id": NSStringFromInteger(di.infoId) }
                           completion:^(id result, BOOL succeed) {
                               if ( succeed ) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateDeliverInfoSuccessNotification"
                                                                                       object:di];
                               } else {
                                   [Toast showText:@"更新收货信息失败"];
                               }
                           }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delete:(UIButton *)sender
{
    [ModalAlert ask:@"确定要删除吗？"
                 message:nil
             result:^(BOOL yesOrNo) {
         if ( yesOrNo ) {
             int index = sender.tag - 1000;
             DeliverInfo* info = [_dataSource objectAtIndex:index];
             [[DataService sharedService] post:[NSString stringWithFormat:@"/deliver_infos/%d",info.infoId]
                                        params:@{ @"token" : [[UserService sharedService] token] }
                                    completion:^(id result, BOOL succeed) {
                                        [_dataSource removeObjectAtIndex:index];
                                        [_tableView reloadData];
                                        if ( [_dataSource count] == 0 ||
                                            [self.userData infoId] == info.infoId) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeliverInfoDidRemoveAll" object:nil];
                                        }
                                    }];
         }
    }];
        
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
