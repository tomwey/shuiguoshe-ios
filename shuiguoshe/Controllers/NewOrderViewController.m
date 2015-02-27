//
//  NewOrderViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NewOrderViewController.h"
#import "Defines.h"

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    
    CGRect bounds = self.view.bounds;
    bounds.size.height -= 49;
    
    _tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
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
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenBounds) - 49,
                                                                     CGRectGetWidth(mainScreenBounds), 49)];
    [self.view addSubview:toolbar];
    [toolbar release];
    
    _resultLabel = createLabel(CGRectMake(0, 0, 240, 37), NSTextAlignmentLeft, [UIColor blackColor], [UIFont systemFontOfSize:14]);
    UIBarButtonItem* textItem = [[[UIBarButtonItem alloc] initWithCustomView:_resultLabel] autorelease];
    
    UIBarButtonItem* flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil] autorelease];
    
    
    UIBarButtonItem* commitItem = [[[UIBarButtonItem alloc] initWithCustomView:commitBtn] autorelease];
    
    toolbar.items = @[textItem, flexItem, commitItem];
    
    __block NewOrderViewController* me = self;
    [MBProgressHUD showHUDAddedTo:AppWindow() animated:YES];
    [[DataService sharedService] loadEntityForClass:@"NewOrderInfo"
                                                URI:[NSString stringWithFormat:@"/cart/items?token=%@", [[UserService sharedService] token]]
                                         completion:^(id result, BOOL succeed) {
                                             [MBProgressHUD hideHUDForView:AppWindow() animated:YES];
                                             if ( succeed ) {
                                                 me.orderInfo = result;
                                                 me->_tableView.hidden = NO;
                                                 [me->_tableView reloadData];
                                                 me->_resultLabel.text = [NSString stringWithFormat:@"实付款：￥%.2f",
                                                                          ( me.orderInfo.totalPrice * 100 - me.orderInfo.userScore ) / 100.0];
                                                 commitBtn.enabled = YES;
                                             } else {
                                                 me->_tableView.hidden = YES;
                                             }
                                         }];
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(hideKeyboard)];
//    [self.view addGestureRecognizer:tap];
//    [tap release];
    
}

- (BOOL)shouldShowingCart
{
    return NO;
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
    
    [[DataService sharedService] post:@"/orders" params:@{ @"token": [[UserService sharedService] token],
                                                           @"score": NSStringFromInteger(self.orderInfo.userScore),
                                                           @"order_info": @{
                                                                    @"deliver_info_id": NSStringFromInteger(self.orderInfo.deliverInfo.infoId),
                                                                    @"note": [_noteField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                                                    @"total_price": [NSString stringWithFormat:@"%.2f", totalPrice],
                                                                    @"discount_price": [NSString stringWithFormat:@"%.2f", discountPrice]
                                                                    
                                                                   } }
                           completion:^(id result, BOOL succeed) {
                               
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
        
        if ( indexPath.section == 0 ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    CGFloat leftMargin = 15;
    switch (indexPath.section) {
        case 0:
        {
            if ( !self.orderInfo.deliverInfo.address ) {
                UILabel* newLabel = (UILabel *)[cell.contentView viewWithTag:101];
                if ( newLabel == nil ) {
                    newLabel = createLabel(CGRectMake(leftMargin, 5, 200, 34),
                                              NSTextAlignmentLeft,
                                              [UIColor blackColor],
                                              [UIFont systemFontOfSize:16]);
                    newLabel.tag = 101;
                    [cell.contentView addSubview:newLabel];
                    newLabel.text = @"新建收货信息";
                }
                
            } else {
                
                [cell.contentView viewWithTag:101].hidden = YES;
                
                UILabel* mobileLabel = (UILabel *)[cell.contentView viewWithTag:1001];
                if ( mobileLabel == nil ) {
                    mobileLabel = createLabel(CGRectMake(leftMargin, 5, 200, 20),
                                              NSTextAlignmentLeft,
                                              [UIColor blackColor],
                                              [UIFont systemFontOfSize:14]);
                    mobileLabel.tag = 1001;
                    [cell.contentView addSubview:mobileLabel];
                }
                
                mobileLabel.text = [NSString stringWithFormat:@"收货人: %@",
                                    [self.orderInfo.deliverInfo.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
                
                UILabel* addressLabel = (UILabel *)[cell.contentView viewWithTag:1002];
                if ( addressLabel == nil ) {
                    addressLabel = createLabel(CGRectMake(leftMargin, CGRectGetMaxY(mobileLabel.frame), CGRectGetWidth(mainScreenBounds) - 60, 30),
                                              NSTextAlignmentLeft,
                                              RGB(137, 137, 137),
                                              [UIFont systemFontOfSize:14]);
                    addressLabel.tag = 1002;
                    [cell.contentView addSubview:addressLabel];
                    
                    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    addressLabel.numberOfLines = 0;
                }
                addressLabel.text = self.orderInfo.deliverInfo.address;
                
                CGSize size = [addressLabel.text sizeWithFont:addressLabel.font
                                            constrainedToSize:CGSizeMake(CGRectGetWidth(addressLabel.frame), 1000)
                                                lineBreakMode:addressLabel.lineBreakMode];
                CGRect frame = addressLabel.frame;
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
                                         [UIColor blackColor],
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
            // 支付方式
            UILabel* payLabel = (UILabel *)[cell.contentView viewWithTag:1006];
            if ( !payLabel ) {
                payLabel = createLabel(CGRectMake(leftMargin, 3, 100, 30),
                                       NSTextAlignmentLeft,
                                       [UIColor blackColor],
                                       [UIFont boldSystemFontOfSize:14]);
                payLabel.tag = 1006;
                [cell.contentView addSubview:payLabel];
                payLabel.text = @"支付及配送方式";
            }
            
            UILabel* payLabel1 = (UILabel *)[cell.contentView viewWithTag:1007];
            if ( !payLabel1 ) {
                payLabel1 = createLabel(CGRectMake(leftMargin, CGRectGetMaxY(payLabel.frame) + 3, 200, 30),
                                       NSTextAlignmentLeft,
                                       [UIColor blackColor],
                                       [UIFont systemFontOfSize:13]);
                payLabel1.tag = 1007;
                [cell.contentView addSubview:payLabel1];
                payLabel1.text = @"目前只支持货到付款";
                [payLabel1 sizeToFit];
            }
            
            UILabel* payLabel2 = (UILabel *)[cell.contentView viewWithTag:1008];
            if ( !payLabel2 ) {
                payLabel2 = createLabel(CGRectMake(leftMargin, CGRectGetMaxY(payLabel1.frame), 200, 30),
                                       NSTextAlignmentLeft,
                                       [UIColor blackColor],
                                       [UIFont systemFontOfSize:13]);
                payLabel2.tag = 1008;
                [cell.contentView addSubview:payLabel2];
                payLabel2.text = @"每天18:00-21:00之间配送";
                [payLabel2 sizeToFit];
            }
            
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
                label = createLabel(CGRectMake(leftMargin, 7, 60, 30),
                                    NSTextAlignmentLeft,
                                    [UIColor blackColor],
                                    [UIFont systemFontOfSize:14]);
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
                                    [UIFont systemFontOfSize:14]);
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
                                         [UIColor blackColor],
                                         [UIFont systemFontOfSize:14]);
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
                
                //            Checkbox* cb = (Checkbox *)[cell.contentView viewWithTag:2004];
                //            if ( !cb ) {
                //                cb = [[[Checkbox alloc] init] autorelease];
                //                cb.tag = 2004;
                //                [cell.contentView addSubview:cb];
                //                cb.labelFont = [UIFont systemFontOfSize:12];
                //            }
                //
                //            cb.label = [NSString stringWithFormat:@"您当前可用积分为%d, 可以抵扣%.2f元", self.orderInfo.userScore, self.orderInfo.userScore / 100.0];
                //            CGRect frame = cb.frame;
                //            frame.origin = CGPointMake(5, CGRectGetMaxY(discountLabel.frame) - 10);
                //            cb.frame = frame;
                
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
        
        CGSize size = [di.address sizeWithFont:[UIFont systemFontOfSize:14]
                             constrainedToSize:CGSizeMake(CGRectGetWidth(mainScreenBounds) - 80, 1000)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        return 30 + size.height;
    }
    
    if ( indexPath.section == 1 ) {
        return 90;
    }
    
    if ( indexPath.section == 2 && indexPath.row == 0 ) {
        return 75;
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
    if ( indexPath.section == 0 && indexPath.row == 0 ) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
