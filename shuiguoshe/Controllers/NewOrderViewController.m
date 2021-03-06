//
//  NewOrderViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NewOrderViewController.h"
#import "Defines.h"

#define kAddressPrefix @"收货地址："

@interface NewOrderViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NewOrderInfo* orderInfo;

@end

@implementation NewOrderViewController
{
    UITextField* _noteField;
    UITableView* _tableView;
    
    UILabel*     _discountLabel;
    
    UILabel*     _resultLabel;
    
    NSInteger    _discountPrice;
    
    UILabel*     _newLabel;
    UILabel*     _mobileLabel;
    UILabel*     _addressLabel;
    
    UIButton*    _commitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 49 + NavigationBarHeight();
    
    _tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.backgroundView = nil;
    
//    _tableView.sectionHeaderHeight = 10;
//    _tableView.sectionFooterHeight = 5;
    
    UIButton* commitBtn = [[CoordinatorController sharedInstance] createTextButton:@"提交订单"
                                                                              font:[UIFont systemFontOfSize:14]
                                                                        titleColor:[UIColor whiteColor]
                                                                           command:nil];
    commitBtn.backgroundColor = GREEN_COLOR;
    CGRect frame = commitBtn.frame;
    frame.size = CGSizeMake(75, 34);
    commitBtn.frame = frame;
    commitBtn.layer.cornerRadius = 2;
    commitBtn.clipsToBounds = YES;
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.enabled = NO;
    
    _commitBtn = commitBtn;
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenBounds) - 49 - NavigationBarAndStatusBarHeight(),
                                                                     CGRectGetWidth(mainScreenBounds), 49)];
    [self.view addSubview:toolbar];
    [toolbar release];
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        [toolbar setTintColor:[UIColor whiteColor]];
    }
    
    _resultLabel = createLabel(CGRectMake(0, 0, 240, 37), NSTextAlignmentLeft, COMMON_TEXT_COLOR, [UIFont boldSystemFontOfSize:fontSize(14)]);
    UIBarButtonItem* textItem = [[[UIBarButtonItem alloc] initWithCustomView:_resultLabel] autorelease];
    
    UIBarButtonItem* flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil] autorelease];
    
    
    UIBarButtonItem* commitItem = [[[UIBarButtonItem alloc] initWithCustomView:commitBtn] autorelease];
    
    toolbar.items = @[textItem, flexItem, commitItem];
    
    _tableView.delegate = self;
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateDeliverInfo:)
                                                 name:@"kUpdateDeliverInfoSuccessNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateDeliverInfo:)
                                                 name:@"kDeliverInfoDidRemoveAll"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdatePaymentAndShipmentInfo:)
                                                 name:@"kPaymentAndShipmentInfoDidUpdateNotification"
                                               object:nil];
}

- (BOOL)shouldShowingCart
{
    return NO;
}

- (void)didUpdateDeliverInfo:(NSNotification *)noti
{
    self.orderInfo.deliverInfo = noti.object;
    if ( noti.object == nil ) {
        _newLabel.hidden = NO;
        _newLabel.text = @"新建收获信息";
        
        _mobileLabel.hidden = _addressLabel.hidden = YES;
    } else {
        _newLabel.hidden = YES;
        
        _mobileLabel.hidden = _addressLabel.hidden = NO;
    }
    [_tableView reloadData];
}

- (void)didUpdatePaymentAndShipmentInfo:(NSNotification *)noti
{
    [self loadData];
}

- (void)loadData
{
    __block NewOrderViewController* me = self;
    NSString* uri = [NSString stringWithFormat:@"/cart/items?token=%@&area_id=%d",
                     [[UserService sharedService] token],
                     [[[DataService sharedService] areaForLocal] oid]];
    
    [[DataService sharedService] loadEntityForClass:@"NewOrderInfo"
                                                URI:uri
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 me.orderInfo = result;
                                                 me->_tableView.hidden = NO;
                                                 
                                                 _tableView.dataSource = self;
                                                 
                                                 [me->_tableView reloadData];
                                                 me->_resultLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f",
                                                                          ( me.orderInfo.totalPrice * 100 - me.orderInfo.userScore ) / 100.0];
                                                 _commitBtn.enabled = YES;
                                             } else {
                                                 me->_tableView.hidden = YES;
                                             }
                                         }];
}

- (void)commit
{
    if ( self.orderInfo.deliverInfo.infoId <= 0 ) {
        [Toast showText:@"必须设置收货信息"];
        return;
    }
    
    CGFloat discountPrice = self.orderInfo.userScore / 100.0;
    int total = ( self.orderInfo.totalPrice * 100 - self.orderInfo.userScore );
    CGFloat totalPrice = total / 100.0;
    NSString* note = [_noteField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( !note ) {
        note = @"";
    }
    [[DataService sharedService] post:@"/user/orders"
                               params:@{ @"token": [[UserService sharedService] token],
                                         @"score": NSStringFromInteger(self.orderInfo.userScore),
                                         @"deliver_info_id": NSStringFromInteger(self.orderInfo.deliverInfo.infoId),
                                         @"note": note,
                                         @"total_fee": [NSString stringWithFormat:@"%.2f", totalPrice],
                                         @"discount_fee": [NSString stringWithFormat:@"%.2f", discountPrice],
                                         @"payment_type": NSStringFromInteger(self.orderInfo.paymentInfo.oid),
                                         @"shipment_type": NSStringFromInteger(self.orderInfo.shipmentInfo.oid),
                                         @"area_id": NSStringFromInteger([[[DataService sharedService] areaForLocal] oid]),
                                        }
                           completion:^(NetworkResponse* resp)
     {
         if ( !resp.requestSuccess ) {
             [Toast showText:@"呃，系统出错了"];
         } else {
           if ( resp.statusCode == 0 ) {
               [[CartService sharedService] initTotal:0];
               
               Order* anOrder = [[[Order alloc] initWithDictionary:resp.result] autorelease];
               Forward* aForward = [Forward buildForwardWithType:ForwardTypePush
                                                            from:self
                                                toControllerName:@"OrderResultViewController"];
               aForward.userData = anOrder;
               
               [[ForwardCommand buildCommandWithForward:aForward] execute];
           } else {
               [Toast showText:resp.message];
           }
             
        }
    }];
}

- (void)hideKeyboard
{
    [_noteField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

static int rows[] = { 1, 1, 1, 1, 1 };
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 1 ) {
        return [self.orderInfo.items count];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell:%d, sec:%d", indexPath.row, indexPath.section];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        
        if ( indexPath.section == 0 ||
            indexPath.section == 2 ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    CGFloat leftMargin = 15;
    CGFloat rowHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
        {
            if ( !self.orderInfo.deliverInfo.address ) {
                UILabel* newLabel = (UILabel *)[cell.contentView viewWithTag:101];
                if ( newLabel == nil ) {
                    newLabel = createLabel(CGRectMake(leftMargin, 5, 200, 34),
                                              NSTextAlignmentLeft,
                                              COMMON_TEXT_COLOR,
                                              [UIFont systemFontOfSize:16]);
                    newLabel.tag = 101;
                    [cell.contentView addSubview:newLabel];
                    newLabel.text = @"新建收货信息";
                }
                
                _newLabel = newLabel;
                
            } else {
                
                [cell.contentView viewWithTag:101].hidden = YES;
                
                // 位置图标
                UIImageView* iconView = (UIImageView *)[cell.contentView viewWithTag:8881];
                if ( !iconView ) {
                    iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_icon.png"]];
                    [iconView sizeToFit];
                    [cell.contentView addSubview:iconView];
                    [iconView release];
                    
                    iconView.tag = 8881;
                }
                
                CGRect frame = iconView.frame;
                frame.origin = CGPointMake(leftMargin, ( rowHeight - CGRectGetHeight(frame) ) / 2);
                iconView.frame = frame;
                
                // 收货人信息
                UILabel* infoLabel = ( UILabel* )[cell.contentView viewWithTag:1001];
                if ( !infoLabel ) {
                    infoLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5, 10, 240, 25),
                                              NSTextAlignmentLeft,
                                              COMMON_TEXT_COLOR,
                                              [UIFont systemFontOfSize:14]);
                    infoLabel.tag = 1001;
                    [cell.contentView addSubview:infoLabel];
                }
                
                _mobileLabel = infoLabel;
                
                NSString* name = self.orderInfo.deliverInfo.name;
                if ( name.length > 8 ) {
                    name = [name substringToIndex:8];
                    name = [NSString stringWithFormat:@"%@...", name];
                }
                
                infoLabel.text = [NSString stringWithFormat:@"收货人: %@  %@",name,
                                    [self.orderInfo.deliverInfo.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
                
                // 收货地址
                UILabel* addressLabel = (UILabel *)[cell.contentView viewWithTag:1002];
                if ( addressLabel == nil ) {
                    addressLabel = createLabel(CGRectMake(CGRectGetMinX(infoLabel.frame),
                                                          CGRectGetMaxY(infoLabel.frame),
                                                          CGRectGetWidth(mainScreenBounds) - 60, 30),
                                              NSTextAlignmentLeft,
                                              RGB(137, 137, 137),
                                              [UIFont systemFontOfSize:14]);
                    addressLabel.tag = 1002;
                    [cell.contentView addSubview:addressLabel];
                    
                    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    addressLabel.numberOfLines = 0;
                    
                }
                
                addressLabel.text = [NSString stringWithFormat:@"%@%@", kAddressPrefix, self.orderInfo.deliverInfo.address];
                _addressLabel = addressLabel;
                
                CGSize size = [addressLabel.text sizeWithFont:addressLabel.font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(addressLabel.frame), 1000)
                                                lineBreakMode:addressLabel.lineBreakMode];
                frame = addressLabel.frame;
                frame.size.height = size.height;
                addressLabel.frame = frame;
            }
        }
            break;
        case 1:
        {
            
            UIImageView* iconView = (UIImageView *)[cell.contentView viewWithTag:1002];
            
            LineItem* item = [self.orderInfo.items objectAtIndex:indexPath.row];
            
            if ( !iconView ) {
                iconView = [[[UIImageView alloc] init] autorelease];
                [cell.contentView addSubview:iconView];
                iconView.tag = 1002;
                
                CGFloat top = 10;
                iconView.frame = CGRectMake(leftMargin, top, 84, 70);
                iconView.userInteractionEnabled = YES;
                
                ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                            from:self
                                                                                                toControllerName:@"ItemDetailViewController"]];
                
                Item* anItem = [[[Item alloc] init] autorelease];
                anItem.iid = item.itemId;
                anItem.title = item.itemTitle;
                anItem.lowPrice = [NSString stringWithFormat:@"￥%.2f", item.price];
                aCommand.userData = anItem;
                CommandButton* cmdButton = [[CoordinatorController sharedInstance] createCommandButton:nil
                                                                                               command:aCommand];
                cmdButton.frame = iconView.bounds;
                [iconView addSubview:cmdButton];
            }
            
            [iconView setImageWithURL:[NSURL URLWithString:item.itemIconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            // 标题
            UILabel* titleLabel = (UILabel *)[cell.contentView viewWithTag:1003];
            if ( !titleLabel ) {
                titleLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5,
                                                    CGRectGetMinY(iconView.frame),
                                                    CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(iconView.frame) - 20,
                                                    50),
                                         NSTextAlignmentLeft,
                                         COMMON_TEXT_COLOR,
                                         [UIFont systemFontOfSize:14]);
                titleLabel.tag = 1003;
                [cell.contentView addSubview:titleLabel];
                titleLabel.numberOfLines = 2;
                titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            }
            
            titleLabel.text = [NSString stringWithFormat:@"%@", item.itemTitle];
            [titleLabel sizeToFit];
            
            // 单价
            UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:1004];
            if ( !priceLabel ) {
                priceLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5,
                                                    CGRectGetMaxY(titleLabel.frame),
                                                    CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(iconView.frame) - 20,
                                                    20),
                                         NSTextAlignmentLeft,
                                         GREEN_COLOR,
                                         [UIFont systemFontOfSize:14]);
                priceLabel.tag = 1004;
                [cell.contentView addSubview:priceLabel];
            }
            
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f", item.price];
            [priceLabel sizeToFit];
            
            // 数量
            UILabel* numberLabel = (UILabel *)[cell.contentView viewWithTag:1005];
            if ( !numberLabel ) {
                numberLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 5,
                                                    80 - 17,
                                                    CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(iconView.frame) - 20,
                                                    20),
                                         NSTextAlignmentLeft,
                                         RGB(137,137,137),
                                         [UIFont systemFontOfSize:12]);
                numberLabel.tag = 1005;
                [cell.contentView addSubview:numberLabel];
            }
            
            numberLabel.text = [NSString stringWithFormat:@"× %d", item.quantity];
            
        }
            break;
        case 2:
        {
            
            // 支付及配送
            UILabel* payLabel = (UILabel *)[cell.contentView viewWithTag:1006];
            if ( !payLabel ) {
                payLabel = createLabel(CGRectMake(leftMargin, ( rowHeight - 30 ) / 2, 100, 30),
                                       NSTextAlignmentLeft,
                                       COMMON_TEXT_COLOR,
                                       [UIFont boldSystemFontOfSize:fontSize(14)]);
                payLabel.tag = 1006;
                [cell.contentView addSubview:payLabel];
                payLabel.text = @"支付配送";
            }
            
            // 支付方式
            UILabel* payLabel1 = (UILabel *)[cell.contentView viewWithTag:1007];
            if ( !payLabel1 ) {
                payLabel1 = createLabel(CGRectMake(CGRectGetWidth(mainScreenBounds) - 40 - 200, 5, 200, 25),
                                       NSTextAlignmentRight,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:fontSize(14)]);
                payLabel1.tag = 1007;
                [cell.contentView addSubview:payLabel1];
            }
            
            payLabel1.text = self.orderInfo.paymentInfo.name;
            
            // 配送方式
            CGRect frame = payLabel1.frame;
            frame.origin.y = CGRectGetMaxY(frame);
            UILabel* shipLabel2 = (UILabel *)[cell.contentView viewWithTag:1008];
            if ( !shipLabel2 ) {
                shipLabel2 = createLabel(frame,
                                       NSTextAlignmentRight,
                                       COMMON_TEXT_COLOR,
                                       [UIFont systemFontOfSize:fontSize(12)]);
                shipLabel2.tag = 1008;
                [cell.contentView addSubview:shipLabel2];
                
                shipLabel2.adjustsFontSizeToFitWidth = YES;
                
            }
            
            shipLabel2.text = [NSString stringWithFormat:@"%@%@配送",
                               self.orderInfo.shipmentInfo.prefix,
                               self.orderInfo.shipmentInfo.name];
        }
            break;
        case 3:
        {
            if ( !_noteField ) {
                _noteField = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, 4, CGRectGetWidth(mainScreenBounds) - leftMargin * 2, 37)];
                [cell.contentView addSubview:_noteField];
                [_noteField release];
                
                _noteField.placeholder = @"填写订单备注（可选）";
                
                _noteField.delegate = self;
                _noteField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _noteField.returnKeyType = UIReturnKeyDone;
                _noteField.font = [UIFont systemFontOfSize:14];
            }
        }
            break;
        case 4:
        {
            // 商品金额
            UILabel* label = (UILabel *)[cell.contentView viewWithTag:1009];
            if ( !label ) {
                label = createLabel(CGRectMake(leftMargin, 7, 100, 30),
                                    NSTextAlignmentLeft,
                                    COMMON_TEXT_COLOR,
                                    [UIFont boldSystemFontOfSize:fontSize(14)]);
                label.tag = 1009;
                [cell.contentView addSubview:label];
                label.text = @"商品金额";
            }
            
            //
            UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:2001];
            if ( !priceLabel ) {
                priceLabel = createLabel(CGRectMake(CGRectGetWidth(mainScreenBounds) - leftMargin - 160,
                                                    CGRectGetMinY(label.frame), 160, 30),
                                    NSTextAlignmentRight,
                                    GREEN_COLOR,
                                    [UIFont systemFontOfSize:fontSize(14)]);
                priceLabel.tag = 2001;
                [cell.contentView addSubview:priceLabel];
            }
            
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderInfo.totalPrice];
            
            if ( self.orderInfo.userScore > 0 ) {
                // 抵扣
                UILabel* dLabel = (UILabel *)[cell.contentView viewWithTag:2002];
                if ( !dLabel ) {
                    dLabel = createLabel(CGRectMake(leftMargin, CGRectGetMaxY(priceLabel.frame), 160, 30),
                                         NSTextAlignmentLeft,
                                         COMMON_TEXT_COLOR,
                                         [UIFont boldSystemFontOfSize:fontSize(14)]);
                    dLabel.tag = 2002;
                    [cell.contentView addSubview:dLabel];
                    dLabel.text = @"抵扣";
                }
                
                //
                UILabel* discountLabel = (UILabel *)[cell.contentView viewWithTag:2003];
                if ( !discountLabel ) {
                    discountLabel = createLabel(CGRectMake(CGRectGetWidth(mainScreenBounds) - leftMargin - 160,
                                                           CGRectGetMaxY(priceLabel.frame), 160, 30),
                                                NSTextAlignmentRight,
                                                GREEN_COLOR,
                                                [UIFont systemFontOfSize:14]);
                    discountLabel.tag = 2003;
                    [cell.contentView addSubview:discountLabel];
                }
                
                discountLabel.text = [NSString stringWithFormat:@"-￥%.2f", self.orderInfo.userScore / 100.0];
                _discountLabel = discountLabel;
                
                _discountPrice = self.orderInfo.userScore;
                
                UILabel* dLabel2 = (UILabel *)[cell.contentView viewWithTag:2004];
                if ( !dLabel2 ) {
                    dLabel2 = createLabel(CGRectMake(leftMargin, CGRectGetMaxY(discountLabel.frame) + 5, 160, 30),
                                          NSTextAlignmentLeft,
                                          GREEN_COLOR,
                                          [UIFont systemFontOfSize:14]);
                    dLabel2.tag = 2004;
                    [cell.contentView addSubview:dLabel2];
                    dLabel2.adjustsFontSizeToFitWidth = YES;
                    
                }
                
                dLabel2.text = [NSString stringWithFormat:@"可用积分为%d，抵扣%.2f元", self.orderInfo.userScore, self.orderInfo.userScore / 100.0];
                
                UISwitch* onOff = (UISwitch *)[cell.contentView viewWithTag:2005];
                if ( !onOff ) {
                    onOff = [[UISwitch alloc] initWithFrame:CGRectZero];
                    [cell.contentView addSubview:onOff];
                    onOff.tag = 2005;
                    [onOff release];
                    
                    CGRect frame = onOff.frame;
                    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) - leftMargin - CGRectGetWidth(frame),
                                               65);
                    onOff.frame = frame;
                    onOff.on = YES;
                    
                    [onOff addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
                }
                
                dLabel2.frame = CGRectMake(leftMargin, CGRectGetMaxY(discountLabel.frame),
                                           CGRectGetWidth(mainScreenBounds) - leftMargin * 2 - CGRectGetWidth(onOff.frame) - 5,
                                           30);
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)changeValue:(UISwitch *)sender
{
    if ( sender.isOn ) {
        _discountPrice = self.orderInfo.userScore;
        _discountLabel.text = [NSString stringWithFormat:@"-￥%.2f", self.orderInfo.userScore / 100.0];
        _resultLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f",
                             ( self.orderInfo.totalPrice * 100 - self.orderInfo.userScore ) / 100.0];
    } else {
        _discountPrice = 0;
        _discountLabel.text = @"-￥0.00";
        _resultLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f",self.orderInfo.totalPrice];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 && indexPath.row == 0 ) {
        DeliverInfo* di = self.orderInfo.deliverInfo;
        if ( !di.address ) {
            return 44;
        }
        
        NSString* text = [NSString stringWithFormat:@"%@%@", kAddressPrefix, di.address];
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14]
                            constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - 60, 1000)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        return 20 + size.height + 25;
    }
    
    if ( indexPath.section == 1 ) {
        return 90;
    }
    
    if ( indexPath.section == 2 && indexPath.row == 0 ) {
        return 60;
    }
    
    if ( indexPath.section == 3 && indexPath.row == 0 ) {
        return 44;
    }
    
    if ( indexPath.section == 4 && indexPath.row == 0 ) {
        if ( self.orderInfo.userScore > 0 ) {
            return 105;
        }
        
        return 44;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.section == 0 && indexPath.row == 0 ) {
        
        Forward* aForward = [Forward buildForwardWithType:ForwardTypePush
                                                     from:self
                                         toControllerName:@"DeliverInfoListViewController"];
        
        aForward.userData = self.orderInfo.deliverInfo;
        
        ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
        
        [aCommand execute];
    } else if ( indexPath.section == 2 && indexPath.row == 0 ) {
        Forward* aForward = [Forward buildForwardWithType:ForwardTypePush
                                                     from:self
                                         toControllerName:@"PaymentAndShipmentUpdateViewController"];
        
        aForward.userData = [NSString stringWithFormat:@"%d-%d", self.orderInfo.paymentInfo.oid, self.orderInfo.shipmentInfo.oid];
        
        ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
        
        [aCommand execute];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_noteField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.35
                     animations:^{
                         CGPoint offset = _tableView.contentOffset;
                         offset.y += 140;
                         _tableView.contentOffset = offset;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(InputTextField *)textField
{
    [UIView animateWithDuration:.35
                     animations:^{
                         CGPoint offset = _tableView.contentOffset;
                         offset.y -= 140;
                         _tableView.contentOffset = offset;
                     } completion:^(BOOL finished) {
                         
                     }];
}

@end
