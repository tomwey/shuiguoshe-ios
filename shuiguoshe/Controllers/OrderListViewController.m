//
//  OrderListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderListViewController.h"
#import "Defines.h"

@interface OrderListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString* filter;
@property (nonatomic, retain) OrderCollection* orderCollection;

@end

@implementation OrderListViewController
{
    UITableView* _tableView;
    int _currentPage;
    NSMutableArray* _dataSource;
}

- (BOOL) shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch ([self.userData integerValue]) {
        case -1:
        {
            self.title = @"全部订单";
            self.filter = @"all";
        }
            break;
        case OrderStateTypeCanceled:
        {
            self.title = @"已取消订单";
            self.filter = @"canceled";
        }
            break;
        case OrderStateTypeDelivering:
        {
            self.title = @"待配送订单";
            self.filter = @"delivering";
        }
            break;
        case OrderStateTypeNoPay:
        {
            self.title = @"待付款订单";
            self.filter = @"no_pay";
        }
            break;
            
        default:
            break;
    }

    _dataSource = [[NSMutableArray alloc] init];
    
    CGRect frame = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _currentPage = 1;
    [self loadOrders:_currentPage showLoading: YES];

    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGB(235, 235, 235);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderItemDidSelect:)
                                                 name:@"kOrderItemDidSelectNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderFinishPayment)
                                                 name:@"kOrderFinishedPaymentNotification"
                                               object:nil];
    
}

- (void)orderFinishPayment
{
    _currentPage = 1;
    [_dataSource removeAllObjects];
    [self loadOrders:_currentPage showLoading:YES];
}

- (void)loadOrders:(int)page showLoading:(BOOL)flag
{
    [[DataService sharedService] loadEntityForClass:@"OrderCollection"
                                                URI:[NSString stringWithFormat:@"/user/orders?token=%@&filter=%@&page=%d",
                                                     [[UserService sharedService] token],
                                                     self.filter, page]
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 self.orderCollection = result;
                                                 [_dataSource addObjectsFromArray:self.orderCollection.orders];
                                                 [_tableView reloadData];
                                             } else {
                                                 
                                             }
                                             
                                         } showLoading:flag];
}

- (void)orderItemDidSelect:(NSNotification *)noti
{
    ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                from:self
                                                                                    toControllerName:@"ItemDetailViewController"]];
    
    LineItem* item = noti.object;
    
    Item* anItem = [[[Item alloc] init] autorelease];
    anItem.iid = item.itemId;
    anItem.title = item.itemTitle;
    anItem.lowPrice = [NSString stringWithFormat:@"￥%.2f", item.price];
    aCommand.userData = anItem;
    [aCommand execute];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell:%d, sec:%d", indexPath.row, indexPath.section];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OrderCellView* view = (OrderCellView *)[cell.contentView viewWithTag:1000];
    if ( !view ) {
        view = [[[OrderCellView alloc] init] autorelease];
        [cell.contentView addSubview:view];
        view.tag = 1000;
    }
    
    [view setOrderInfo:[_dataSource objectAtIndex:indexPath.row]];
    
    CGRect frame = view.frame;
    frame.origin = CGPointMake(0, 20);
    view.frame = frame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfo* info = [_dataSource objectAtIndex:indexPath.row];
    return 140 + [info.items count] * 65 - 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [_dataSource count] == indexPath.row + 1 ) {
        if ( _currentPage < self.orderCollection.totalPage ) {
            _currentPage ++;
            [self loadOrders:_currentPage showLoading: NO];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_dataSource release];
    self.filter = nil;
    self.orderCollection = nil;
    [super dealloc];
}

@end
