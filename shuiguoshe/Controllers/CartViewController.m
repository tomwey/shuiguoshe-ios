//
//  CartViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) Cart* currentCart;

@end

@implementation CartViewController
{
    UITableView* _tableView;
    UIView*      _toolbar;
    
    UpdateValueLabel* _resultLabel;
    
    Checkbox*      _selectAll;
    CheckboxGroup* _checkboxGroup;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的购物车";
    
    _checkboxGroup = [[CheckboxGroup alloc] init];
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self
                                                      toController:nil]]];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= (49 + NavigationBarHeight());
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 308/2;
    
    _tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    if ( [_tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ( [_tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [self initToolbar];
    
    [self loadData];
}

- (void)loadData
{
    __block CartViewController* me = self;
    NSString* uri = [NSString stringWithFormat:@"/user/cart?token=%@&area_id=%d",
                     [[UserService sharedService] token],
                     [[[DataService sharedService] areaForLocal] oid]];
    
    [[DataService sharedService] loadEntityForClass:@"Cart"
                                                URI:uri
                                         completion:^(id result, BOOL succeed)
     {
         me.currentCart = result;
         if ( !result ) {
             me->_toolbar.hidden = YES;
             me->_tableView.hidden = YES;
             
             UILabel* label = createLabel(CGRectMake(0,
                                                     100,
                                                     CGRectGetWidth(mainScreenBounds),
                                                     50),
                                          NSTextAlignmentCenter,
                                          COMMON_TEXT_COLOR,
                                          [UIFont systemFontOfSize:fontSize(16)]);
             label.text = @"购物车是空的";
             [me.view addSubview:label];
             
         } else {
             me->_resultLabel.value = [NSString stringWithFormat:@"￥%.2f",me.currentCart.totalPrice];
             
             me->_toolbar.hidden = NO;
             me->_tableView.hidden = NO;
             
             [me->_tableView reloadData];
             
             NSArray* items = me.currentCart.items;
             BOOL flag = YES;
             for (LineItem* item in items) {
                 flag &= item.visible;
             }
             
             _selectAll.checked = flag;
         }
         
         [[CartService sharedService] initTotal:self.currentCart.totalQuantity];
         
     }];
}

- (void)initToolbar
{
    _toolbar = [[UIView alloc] initWithFrame:
                CGRectMake(0, CGRectGetHeight(mainScreenBounds) -
                           49 - NavigationBarAndStatusBarHeight(),
                           CGRectGetWidth(mainScreenBounds),49)];
    [self.view addSubview:_toolbar];
    _toolbar.hidden = YES;
    [_toolbar release];
    _toolbar.backgroundColor = [UIColor whiteColor];
    
    // 上边线
    UIView* topLine = [[UIView alloc] initWithFrame:
                       CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 0.3)];
    [_toolbar addSubview:topLine];
    [topLine release];
    
    topLine.backgroundColor = RGB(207,207,207);
    
    // 全选按钮
    _selectAll = [[[Checkbox alloc] init] autorelease];
    _selectAll.labelFont = [UIFont systemFontOfSize:fontSize(14)];
    _selectAll.label = @"全选";
    _selectAll.checkboxType = CheckboxTypeSelectAll;
    _selectAll.checkboxGroup = _checkboxGroup;
    
    [_toolbar addSubview:_selectAll];
    
    CGRect frame = _selectAll.frame;
    frame.origin = CGPointMake( 5, ( 49 - CGRectGetHeight(frame) ) / 2 );
    _selectAll.frame = frame;
    
    __block CartViewController* me = self;
    
    _selectAll.didUpdateStateBlock = ^(Checkbox *cb) {
        if ( cb.checked ) {
            for ( LineItem* item in me.currentCart.items ) {
                item.visible = YES;
            }
            
            [me updateCartResult];
        } else {
            for ( LineItem* item in me.currentCart.items ) {
                item.visible = NO;
            }
            
            me->_resultLabel.value = @"0.00";
        }
    };
    
    // 总计
    _resultLabel = [[UpdateValueLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 49)];
    _resultLabel.backgroundColor = [UIColor clearColor];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    _resultLabel.textColor = COMMON_TEXT_COLOR;
    _resultLabel.prefix = @"总计：";
    _resultLabel.font = [UIFont boldSystemFontOfSize:fontSize(14)];
    
    [_toolbar addSubview:_resultLabel];
    [_resultLabel release];
    
    // 结算
    UIButton* cmdBtn = createButton(@"btn_calcu.png", self, @selector(checkout));
    [_toolbar addSubview:cmdBtn];
    
    frame = cmdBtn.frame;
    frame.origin = CGPointMake(CGRectGetWidth(mainScreenBounds) - 15 - CGRectGetWidth(frame),
                               ( 49 - CGRectGetHeight(frame) ) / 2);
    cmdBtn.frame = frame;
}

- (void)checkout
{
    BOOL flag = NO;
    for (LineItem* item in self.currentCart.items) {
        flag |= item.visible;
    }
    
    if ( !flag ) {
        [Toast showText:@"当前购物车没有选中商品"];
        return;
    }
    
    [self.navigationController pushViewController:[[[NSClassFromString(@"NewOrderViewController") alloc] init] autorelease] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentCart.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ( [cell respondsToSelector:@selector(setLayoutMargins:)] ) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    [self addContentForCell:cell atRow:indexPath.row];
    
    return cell;
}

- (void)addContentForCell:(UITableViewCell *)cell atRow:(NSInteger)row
{
    LineItem *item = [self itemForRow:row];
    
    Checkbox* cb = (Checkbox *)[cell.contentView viewWithTag:1001];
    if ( !cb ) {
        cb = [[[Checkbox alloc] init] autorelease];
        cb.tag = 1001;
        [cell.contentView addSubview:cb];
        
        cb.center = CGPointMake(5 + CGRectGetWidth(cb.bounds)/2, _tableView.rowHeight / 2);
        
        cb.checkboxGroup = _checkboxGroup;
    }
    
    cb.currentItem = item;
    cb.checked = item.visible;
    
    CGFloat top = 10;
    UIImageView* iconView = (UIImageView *)[cell.contentView viewWithTag:1002];
    
    if ( !iconView ) {
        iconView = [[[UIImageView alloc] init] autorelease];
        [cell.contentView addSubview:iconView];
        iconView.tag = 1002;
        
        iconView.frame = CGRectMake(CGRectGetMaxX(cb.frame) + 5, top, 108, 90);
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
        titleLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 8,
                                            CGRectGetMinY(iconView.frame),
                                            CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(iconView.frame) - 20,40),
                                 NSTextAlignmentLeft,
                                 COMMON_TEXT_COLOR,
                                 [UIFont systemFontOfSize:fontSize(14)]);
        titleLabel.tag = 1003;
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:titleLabel];
    }
    
    titleLabel.text = item.itemTitle;
    [titleLabel sizeToFit];
    
    // 单价
    UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:1004];
    if ( !priceLabel ) {
        priceLabel = createLabel(CGRectMake(CGRectGetMinX(titleLabel.frame),
                                            CGRectGetMinY(titleLabel.frame) + 32,
                                            200,
                                            30),
                                 NSTextAlignmentLeft,
                                 GREEN_COLOR,
                                 [UIFont systemFontOfSize:fontSize(14)]);
        priceLabel.tag = 1004;
        [cell.contentView addSubview:priceLabel];
    }
//    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", item.price];
    
    
    NSString* priceText = [NSString stringWithFormat:@"￥%.2f • %@", item.price, item.itemUnit];
    
    NSRange range = [priceText rangeOfString:@"•"];
    range.length = priceText.length - range.location;
    
    NSMutableAttributedString* string =
    [[[NSMutableAttributedString alloc] initWithString:priceText] autorelease];
    [string addAttributes:@{ NSForegroundColorAttributeName: COMMON_TEXT_COLOR }
                    range:range];
    priceLabel.attributedText = string;
    
    // 更新数量控件
    NumberControl* nc = (NumberControl *)[cell.contentView viewWithTag:1005];
    if ( nc == nil ) {
        nc = [[[NumberControl alloc] init] autorelease];
        nc.tag = 1005;
        [cell.contentView addSubview:nc];
        
        CGRect frame = nc.frame;
        frame.origin = CGPointMake(CGRectGetMinX(priceLabel.frame), CGRectGetMaxY(priceLabel.frame));
        nc.frame = frame;
    }
    
    nc.itemId = item.objectId;
    nc.value = item.quantity;
    
    // 分隔线
    UIView* lineView = [cell.contentView viewWithTag:1006];
    if ( lineView == nil ) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(iconView.frame),
                                                            CGRectGetMaxY(iconView.frame) + 10,
                                                            CGRectGetWidth(mainScreenBounds) - CGRectGetMinX(iconView.frame),
                                                            .3)];
        [cell.contentView addSubview:lineView];
        [lineView release];
        lineView.tag = 1006;
        lineView.backgroundColor = RGB(224, 224, 224);
    }
    
    // 小计
    UpdateValueLabel* label = (UpdateValueLabel *)[cell.contentView viewWithTag:1007];
    if ( !label ) {
        label = [[UpdateValueLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lineView.frame),
                                                          CGRectGetMaxY(lineView.frame) + 5,
                                                          CGRectGetWidth(lineView.frame),
                                                          30)];
        [cell.contentView addSubview:label];
        [label release];
        label.tag = 1007;
        label.font = [UIFont systemFontOfSize:fontSize(14)];
        label.textColor = GREEN_COLOR;
        
        label.prefix = @"小计：";
    }
    
    label.value = [NSString stringWithFormat:@"￥%.2f",item.totalPrice];
    
    // 更新信息
    __block CartViewController* me = self;
    
    nc.finishUpdatingBlock = ^(NSInteger currentValue) {
        
        CGFloat total = item.price * currentValue;
        label.value = [NSString stringWithFormat:@"￥%.2f",total];
        
        cb.checked = YES;
        cb.currentItem.visible = YES;
        
        cb.currentItem.totalPrice = total;
        
        [me updateCartResult];
    };
    
    cb.didUpdateStateBlock = ^(Checkbox* aCb) {
        cb.currentItem.visible = aCb.checked;
        [me updateCartResult];
    };
}

- (void)updateCartResult
{
    float sum = 0;
    for ( LineItem* item in self.currentCart.items ) {
        if ( item.visible ) {
            sum += item.totalPrice;
        }
    }
    
    _resultLabel.value = [NSString stringWithFormat:@"￥%.2f", sum];
}

- (LineItem *)itemForRow:(NSInteger)row
{
    if ( row < [self.currentCart.items count] ) return [self.currentCart.items objectAtIndex:row];
    return nil;
}

- (void)dealloc
{
    [_checkboxGroup release];
    self.currentCart = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
