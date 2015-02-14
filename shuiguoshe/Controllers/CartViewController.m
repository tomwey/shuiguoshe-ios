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
}

- (BOOL)shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的购物车";
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self
                                                      toController:nil]]];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 49;
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 188/2;
    
    _tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
    if ( [_tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if ( [_tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    
    [self initToolbar];
    
    __block CartViewController* me = self;
    [[DataService sharedService] loadEntityForClass:@"Cart"
                                                URI:[NSString stringWithFormat:@"/user/cart?token=%@", [[UserService sharedService] token]]
                                         completion:^(id result, BOOL succeed)
    {
        me.currentCart = result;
        [me->_tableView reloadData];
    }];
    
}

- (void)initToolbar
{
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainScreenBounds) - 49,
                                                                     CGRectGetWidth(mainScreenBounds),
                                                                     49)];
    [self.view addSubview:toolbar];
    [toolbar release];
    
    Checkbox* cb = [[[Checkbox alloc] init] autorelease];
    cb.label = @"全选";
    UIBarButtonItem* checkAll = [[[UIBarButtonItem alloc] initWithCustomView:cb] autorelease];
    
    UIBarButtonItem* flexItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil
                                                                                action:nil] autorelease];
    
    // 总计
    UILabel* resultLabel = createLabel(CGRectMake(0, 0, 200, 49),
                                       NSTextAlignmentCenter,
                                       [UIColor blackColor],
                                       [UIFont systemFontOfSize:16]);
    resultLabel.text = @"总计：12.00";
    
    UIBarButtonItem* resultItem = [[[UIBarButtonItem alloc] initWithCustomView:resultLabel] autorelease];
    
    UIBarButtonItem* flexItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                target:nil
                                                                                action:nil] autorelease];
    
    // 结算
    ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                from:self
                                                                                    toControllerName:@"NewOrderViewController"]];
    CommandButton* cmdBtn = [[CoordinatorController sharedInstance] createCommandButton:@"btn_calcu.png"
                                                                                command:aCommand];
    UIBarButtonItem* calcu = [[[UIBarButtonItem alloc] initWithCustomView:cmdBtn] autorelease];
    
    toolbar.items = @[checkAll, flexItem1, resultItem, flexItem2, calcu];
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
    Checkbox* cb = (Checkbox *)[cell.contentView viewWithTag:1001];
    if ( !cb ) {
        cb = [[[Checkbox alloc] init] autorelease];
        cb.tag = 1001;
        [cell.contentView addSubview:cb];
        
        cb.center = CGPointMake(5 + CGRectGetWidth(cb.bounds)/2, _tableView.rowHeight / 2);
    }
    
    CGFloat top = 10;
    UIImageView* iconView = (UIImageView *)[cell.contentView viewWithTag:1002];
    
    LineItem *item = [self itemForRow:row];
    
    if ( !iconView ) {
        iconView = [[[UIImageView alloc] init] autorelease];
        [cell.contentView addSubview:iconView];
        iconView.tag = 1002;
        
        CGFloat height = _tableView.rowHeight - top * 2;
        iconView.frame = CGRectMake(CGRectGetMaxX(cb.frame) + 5, top, height * 6 / 5, height);
        iconView.userInteractionEnabled = YES;
        
        ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                    from:self
                                                                                            toControllerName:@"ItemDetailViewController"]];
        
        Item* anItem = [[[Item alloc] init] autorelease];
        anItem.iid = item.itemId;
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
                                            CGRectGetWidth(mainScreenBounds) - CGRectGetMaxX(iconView.frame) - 10,
                                            37),
                                 NSTextAlignmentLeft,
                                 [UIColor blackColor],
                                 [UIFont boldSystemFontOfSize:14]);
        titleLabel.tag = 1003;
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
    }
    
    CGSize size = [item.itemTitle sizeWithFont:titleLabel.font
                             constrainedToSize:CGSizeMake(CGRectGetWidth(titleLabel.bounds),
                                                          1000)
                                 lineBreakMode:titleLabel.lineBreakMode];
    CGRect frame = titleLabel.frame;
    frame.size.height = size.height;
    titleLabel.frame = frame;
    
    titleLabel.text = item.itemTitle;
    
    // 单价
    UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:1004];
    if ( !priceLabel ) {
        priceLabel = createLabel(CGRectMake(CGRectGetMinX(titleLabel.frame),
                                            CGRectGetMaxY(titleLabel.frame),
                                            CGRectGetWidth(titleLabel.frame),
                                            30),
                                 NSTextAlignmentLeft,
                                 GREEN_COLOR,
                                 [UIFont systemFontOfSize:14]);
        priceLabel.tag = 1004;
        [cell.contentView addSubview:priceLabel];
    }
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f", item.price];
    
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
}

- (LineItem *)itemForRow:(NSInteger)row
{
    if ( row < [self.currentCart.items count] ) return [self.currentCart.items objectAtIndex:row];
    return nil;
}

- (void)dealloc
{
    self.currentCart = nil;
    
    [super dealloc];
}

@end
