//
//  PaymentAndShipmentUpdateViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "PaymentAndShipmentUpdateViewController.h"
#import "Defines.h"

@interface PaymentAndShipmentUpdateViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PaymentShipmentInfo* psInfo;

@end

@implementation PaymentAndShipmentUpdateViewController
{
    CustomButtonGroup* _paymentInfosButtonGroup;
    CustomButtonGroup* _shipmentInfosButtonGroup;
    
    NSInteger _paymentType;
    NSInteger _shipmentType;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付及配送";
    
    // 确定按钮
    UIButton* okBtn = createButton2(@"button_bg2.png", @"确定", self, @selector(save));;
    [okBtn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
    
    CGRect btnFrame = okBtn.frame;
    btnFrame.size.width = 52;
    okBtn.frame = btnFrame;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:okBtn] autorelease];
    
    CGRect frame = self.view.bounds;
    
    // 表视图
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    NSArray* values = [self.userData componentsSeparatedByString:@"-"];
    _paymentType = [[values firstObject] integerValue];
    _shipmentType = [[values lastObject] integerValue];
    
    _paymentInfosButtonGroup = [[CustomButtonGroup alloc] init];
    _shipmentInfosButtonGroup = [[CustomButtonGroup alloc] init];
    
    [[DataService sharedService] loadEntityForClass:@"PaymentShipmentInfo"
                                                URI:@"/payment_and_shipment_infos"
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 
                                                 self.psInfo = result;
                                                 
                                                 tableView.dataSource = self;
                                                 tableView.delegate = self;
                                                 
                                                 [tableView reloadData];
                                             } else {
                                                 
                                             }
                                         }];
    
    if ( [tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
        tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ( [tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
        tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = RGB(246, 246, 246);
}

- (void)dealloc
{
    self.psInfo = nil;
    [_paymentInfosButtonGroup release];
    [_shipmentInfosButtonGroup release];
    [super dealloc];
}

- (void)save
{
    if ( [self.userData isEqualToString:[NSString stringWithFormat:@"%d-%d", _paymentType, _shipmentType]] ) {
        [self handleSuccess];
        return;
    }
    
    [[DataService sharedService] post:@"/user/update_payment_and_shipment_info"
                               params:@{
                                        @"token": [[UserService sharedService] token],
                                        @"payment_type_id": NSStringFromInteger(_paymentType),
                                        @"shipment_type_id": NSStringFromInteger(_shipmentType)
                                        }
                           completion:^(NetworkResponse *resp) {
                               if ( resp.requestSuccess ) {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"kPaymentAndShipmentInfoDidUpdateNotification"
                                                                                       object:nil];
                                   [self handleSuccess];
                               } else {
                                   [Toast showText:@"呃，系统出错了。"];
                               }
    }];
}

- (void)handleSuccess
{
    Forward* aForward = [Forward buildForwardWithType:ForwardTypePop
                                                 from:self
                                         toController:nil];
    [[ForwardCommand buildCommandWithForward:aForward] execute];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* CellId = [NSString stringWithFormat:@"cell-%d", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIView* containerView = [cell.contentView viewWithTag:888];
    if ( !containerView ) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 100)];
        [cell.contentView addSubview:containerView];
        [containerView release];
        
        containerView.tag = 888;
        containerView.backgroundColor = [UIColor whiteColor];
    }
    
    // 上边线
    UIView* topLine = [containerView viewWithTag:10002];
    if ( !topLine ) {
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0,0,
                                                            CGRectGetWidth(mainScreenBounds),
                                                            0.5)];
        [containerView addSubview:topLine];
        [topLine release];
        
        topLine.tag = 10002;
        topLine.backgroundColor = RGB(207, 207, 207);
    }
    
    UILabel* textLabel = (UILabel*)[cell.contentView viewWithTag:1001];
    if ( !textLabel ) {
        textLabel = createLabel(CGRectMake(15, 2, 200, 30),
                                NSTextAlignmentLeft,
                                COMMON_TEXT_COLOR,
                                [UIFont boldSystemFontOfSize:fontSize(16)]);
        textLabel.tag = 1001;
        [containerView addSubview:textLabel];
        
        if ( indexPath.row == 0 ) {
            textLabel.text = @"支付方式";
        } else if ( indexPath.row == 1 ) {
            textLabel.text = @"配送方式";
        }
    }
    
    // 线
    UIView* lineView = [cell.contentView viewWithTag:1002];
    if ( !lineView ) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textLabel.frame),
                                                            CGRectGetWidth(mainScreenBounds),
                                                            0.5)];
        [containerView addSubview:lineView];
        [lineView release];
        
        lineView.tag = 1002;
        lineView.backgroundColor = RGB(207, 207, 207);
    }
    
    if ( indexPath.row == 0 ) {
        [self addPaymentContents:cell atIndexPath:indexPath];
    } else if ( indexPath.row == 1 ) {
        [self addShipmentContents:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)addPaymentContents:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIView* containerView = [cell.contentView viewWithTag:888];
    
    UIView *lineView = [containerView viewWithTag:1002];
    
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( [self numberOfCols] + 1 ) * 15 ) / [self numberOfCols];
    CGFloat height = 33;
    
    CGFloat maxY = 0;
    for (int i=0; i<[self.psInfo.paymentInfos count]; i++) {
        CustomButton* cb = (CustomButton*)[containerView viewWithTag:2000 + i];
        if ( cb == nil ) {
            cb = [[[CustomButton alloc] init] autorelease];
            cb.tag = 2000 + i;
            [containerView addSubview:cb];
            
            NSInteger m = i % [self numberOfCols];
            NSInteger n = i / [self numberOfCols];
            
            cb.frame = CGRectMake(15 + ( 15 + width ) * m,
                                  CGRectGetMaxY(lineView.frame) + 15 + ( 15 + height ) * n,
                                  width,
                                  height);
            
            cb.buttonGroup = _paymentInfosButtonGroup;
        }
        
        PaymentInfo* pi = [self.psInfo.paymentInfos objectAtIndex:i];
        
        cb.title = pi.name;
        if ( pi.oid == _paymentType ) {
            cb.selected = YES;
        } else {
            cb.selected = NO;
        }
        
        __block PaymentAndShipmentUpdateViewController* me = self;
        cb.didClickBlock = ^(CustomButton* button) {
            me->_paymentType = pi.oid;
        };
        
        maxY = CGRectGetMaxY(cb.frame);
    }
    
    // 提示
    UILabel* tipLabel = (UILabel*)[containerView viewWithTag:1003];
    if ( !tipLabel ) {
        tipLabel = createLabel(CGRectMake(15, maxY + 10, 300, 30),
                               NSTextAlignmentLeft,
                               RGB(207, 207, 207),
                               [UIFont systemFontOfSize:fontSize(14)]);
        tipLabel.tag = 1003;
        [containerView addSubview:tipLabel];
        
        tipLabel.text = @"在线支付可支持支付宝";
    }
    
    // 线
    UIView* bottomLine = [containerView viewWithTag:1004];
    if ( !bottomLine ) {
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame) + 10,
                                                              CGRectGetWidth(mainScreenBounds), .5)];
        [containerView addSubview:bottomLine];
        [bottomLine release];
        
        bottomLine.backgroundColor = RGB(207, 207, 207);
        
        bottomLine.tag = 1004;
    }
    
    CGRect frame = containerView.frame;
    frame.size.height = CGRectGetMaxY(bottomLine.frame);
    containerView.frame = frame;
}

- (void)addShipmentContents:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIView* containerView = [cell.contentView viewWithTag:888];
    
    UIView *lineView = [containerView viewWithTag:1002];
    
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( [self numberOfCols] + 1 ) * 15 ) / [self numberOfCols];
    CGFloat height = 33;
    
    CGFloat maxY = 0;
    for (int i=0; i<[self.psInfo.shipmentInfos count]; i++) {
        CustomButton* cb = (CustomButton*)[containerView viewWithTag:3000 + i];
        if ( cb == nil ) {
            cb = [[[CustomButton alloc] init] autorelease];
            cb.tag = 3000 + i;
            [containerView addSubview:cb];
            
            NSInteger m = i % [self numberOfCols];
            NSInteger n = i / [self numberOfCols];
            
            cb.frame = CGRectMake(15 + ( 15 + width ) * m,
                                  CGRectGetMaxY(lineView.frame) + 15 + ( 15 + height ) * n,
                                  width,
                                  height);
            
            cb.buttonGroup = _shipmentInfosButtonGroup;
        }
        
        ShipmentInfo* pi = [self.psInfo.shipmentInfos objectAtIndex:i];
        
        cb.title = pi.name;
        if ( pi.oid == _shipmentType ) {
            cb.selected = YES;
        } else {
            cb.selected = NO;
        }
        
        __block PaymentAndShipmentUpdateViewController* me = self;
        cb.didClickBlock = ^(CustomButton* button) {
            me->_shipmentType = pi.oid;
        };
        
        maxY = CGRectGetMaxY(cb.frame);
    }
    
    // 提示
    UILabel* tipLabel = (UILabel*)[containerView viewWithTag:1003];
    if ( !tipLabel ) {
        tipLabel = createLabel(CGRectMake(15, maxY + 10, 300, 30),
                               NSTextAlignmentLeft,
                               RGB(207, 207, 207),
                               [UIFont systemFontOfSize:fontSize(14)]);
        tipLabel.tag = 1003;
        [containerView addSubview:tipLabel];
        
        tipLabel.text = @"配送时间可能随订单数量而变";
    }
    
    // 线
    UIView* bottomLine = [containerView viewWithTag:1004];
    if ( !bottomLine ) {
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame) + 10,
                                                              CGRectGetWidth(mainScreenBounds), .5)];
        [containerView addSubview:bottomLine];
        [bottomLine release];
        
        bottomLine.backgroundColor = RGB(207, 207, 207);
        
        bottomLine.tag = 1004;
    }
    
    CGRect frame = containerView.frame;
    frame.size.height = CGRectGetMaxY(bottomLine.frame);
    containerView.frame = frame;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = 0;
    if ( indexPath.row == 0 ) {
        count = self.psInfo.paymentInfos.count;
    } else {
        count = self.psInfo.shipmentInfos.count;
    }
    
    NSInteger row = ( count + [self numberOfCols] - 1 ) / [self numberOfCols];
    return row * 33 + ( row + 1 ) * 15 + 40 * 2 + 10;
}

- (NSInteger)numberOfCols
{
    if ( CGRectGetHeight(mainScreenBounds) > 568 ) {
        return 4;
    }
    
    return 3;
}

@end
