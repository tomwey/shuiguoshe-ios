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
    NSMutableArray* _radioButtons;
}

- (BOOL) shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收货信息";
    
    UIButton* newBtn = createButton2(@"button_bg3.png", @"添加", self, @selector(btnClicked));
    [newBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    CGRect frame2 = newBtn.frame;
    frame2.size.width = 52;
    newBtn.frame = frame2;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:newBtn] autorelease];
    
    CGRect frame = self.view.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _dataSource = [[NSMutableArray alloc] init];
    _radioButtons = [[NSMutableArray alloc] init];
    
    UIView* footer = [[[UIView alloc] init] autorelease];
    _tableView.tableFooterView = footer;
    
//    _tableView.rowHeight = 70;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_dataSource removeAllObjects];
    
    [[DataService sharedService] loadEntityForClass:@"DeliverInfo"
                                                URI:[NSString stringWithFormat:@"/deliver_infos?token=%@&area_id=%d",
                                                     [[UserService sharedService] token],
                                                     [[[DataService sharedService] areaForLocal] oid]]
                                         completion:^(id result, BOOL succeed)
     {
         [_dataSource removeAllObjects];
         [_dataSource addObjectsFromArray:result];
         [_tableView reloadData];
     }];
    
}

- (void)btnClicked
{
    [[ForwardCommand buildCommandWithForward:
     [Forward buildForwardWithType:ForwardTypePush from:self
                  toControllerName:@"DeliverInfoFormViewController"]] execute];
}

- (void)dealloc
{
    [_dataSource release];
    [_radioButtons release];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* btn = createButton(nil, self, @selector(delete:));
        btn.tag = 1000 + indexPath.row;
        [cell.contentView addSubview:btn];
        btn.backgroundColor = RGB(201, 62, 59);
        [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 50, 34);
        btn.layer.cornerRadius = 3;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.clipsToBounds = YES;
        
        cell.accessoryView = btn;
    }
    
    DeliverInfo* di = [_dataSource objectAtIndex:indexPath.row];
    
    // 单选框
    RadioButton* cb = (RadioButton *)[cell.contentView viewWithTag:500];
    if ( !cb ) {
        cb = [[[RadioButton alloc] init] autorelease];
        cb.tag = 500;
        [cell.contentView addSubview:cb];
        
        if ( ![_radioButtons containsObject:cb] ) {
            [_radioButtons addObject:cb];
        }
    }
    
    cb.selected = [self.userData infoId] == di.infoId;
    
    __block DeliverInfoListViewController* me = self;
    cb.valueChanged = ^(RadioButton* btn) {
        [[DataService sharedService] post:@"/user/update_deliver_info"
                                   params:@{ @"token": [[UserService sharedService] token],
                                             @"deliver_info_id": NSStringFromInteger(di.infoId),
                                             @"area_id": NSStringFromInteger([[[DataService sharedService] areaForLocal] oid])}
                               completion:^(NetworkResponse* resp) {
                                   if ( !resp.requestSuccess ) {
                                       [Toast showText:@"呃，系统出错了"];
                                   } else {
                                       if ( resp.statusCode == 0 ) {
                                           for (RadioButton* inBtn in me->_radioButtons) {
                                               inBtn.selected = NO;
                                           }
                                           cb.selected = YES;
                                           
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateDeliverInfoSuccessNotification"
                                                                                               object:di];
                                       } else {
                                           [Toast showText:@"更新收货信息失败"];
                                       }
                                   }
                               }];
    };
    
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    CGRect frame2 = cb.frame;
    frame2.origin = CGPointMake(5, ( rowHeight - CGRectGetHeight(frame2) ) / 2 );
    cb.frame = frame2;
    
    // 姓名
    UILabel* name = (UILabel *)[cell.contentView viewWithTag:600];
    if ( !name ) {
        name = createLabel(CGRectMake(CGRectGetMaxX(cb.frame), 5, 100, 30),
                           NSTextAlignmentLeft,
                           COMMON_TEXT_COLOR,
                           [UIFont boldSystemFontOfSize:fontSize(14)]);
        name.tag = 600;
        [cell.contentView addSubview:name];
    }
    
    name.text = di.name;
    
    UILabel* mobile = (UILabel *)[cell.contentView viewWithTag:100];
    if ( !mobile ) {
        mobile = createLabel(CGRectMake(CGRectGetMaxX(name.frame) + 5, CGRectGetMinY(name.frame), 100, 30),
                             NSTextAlignmentLeft,
                             COMMON_TEXT_COLOR,
                             [UIFont systemFontOfSize:fontSize(14)]);
        mobile.tag = 100;
        [cell.contentView addSubview:mobile];
    }
    
    mobile.text = [di.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    // 地址
    UILabel* address = (UILabel *)[cell.contentView viewWithTag:101];
    if ( !address ) {
        address = createLabel(CGRectMake(CGRectGetMinX(name.frame),
                              CGRectGetMaxY(mobile.frame),
                                         CGRectGetWidth(mainScreenBounds) - 60 - CGRectGetWidth(cell.accessoryView.frame) - 20, 37),
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
                           constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - CGRectGetWidth(cb.frame) - CGRectGetWidth(cell.accessoryView.frame) - 20,
                                                        1000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = address.frame;
    frame.size.height = size.height;
    address.frame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliverInfo* di = [_dataSource objectAtIndex:indexPath.row];
    
    CGSize size = [di.address sizeWithFont:[UIFont systemFontOfSize:14]
                           constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - 60 - 20 - 50,
                                                        1000) lineBreakMode:NSLineBreakByWordWrapping];
    return 37 + size.height + 15;
}

- (void)delete:(UIButton *)sender
{
    int index = sender.tag - 1000;
    RadioButton* rb = [_radioButtons objectAtIndex:index];
    if ( rb.selected ) {
        [Toast showText:@"默认收货信息不能被删除"];
        return;
    }
    
    [ModalAlert ask:@"确定要删除吗？"
                 message:nil
             result:^(BOOL yesOrNo) {
         if ( yesOrNo ) {
             DeliverInfo* info = [_dataSource objectAtIndex:index];
             [[DataService sharedService] post:[NSString stringWithFormat:@"/deliver_infos/%d",info.infoId]
                                        params:@{ @"token" : [[UserService sharedService] token] }
                                    completion:^(NetworkResponse* resp) {
                                        if ( !resp.requestSuccess ) {
                                            [Toast showText:@"呃，系统出错了"];
                                        } else {
                                            if ( resp.statusCode == 0 ) {
                                                [_dataSource removeObjectAtIndex:index];
                                                [_tableView reloadData];
                                                if ( [_dataSource count] == 0 ||
                                                    [self.userData infoId] == info.infoId) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeliverInfoDidRemoveAll" object:nil];
                                                }
                                            } else {
                                                [Toast showText:@"删除失败"];
                                            }
                                            
                                        }
                                    }];
         }
    }];
        
}

@end
