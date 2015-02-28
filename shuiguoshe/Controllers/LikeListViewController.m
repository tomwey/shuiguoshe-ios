//
//  LikeListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "LikeListViewController.h"
#import "Defines.h"

@interface LikeListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray* dataSource;
@end

@implementation LikeListViewController
{
    UITableView* _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    
    CGRect frame = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.rowHeight = 80;
    
    _tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[DataService sharedService] loadEntityForClass:@"Like"
                                                URI:[NSString stringWithFormat:@"/user/likes?token=%@", [[UserService sharedService] token]]
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 self.dataSource = result;
                                                 _tableView.hidden = NO;
                                                 [_tableView reloadData];
                                             } else {
                                                 _tableView.hidden = YES;
                                             }
                                             
                                         }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"c%d", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Like* like = [self.dataSource objectAtIndex:indexPath.row];
    
    // icon
    UIImageView* iconView = (UIImageView *)[cell.contentView viewWithTag:100];
    if ( !iconView ) {
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 72, 60)];
        iconView.tag = 100;
        [cell.contentView addSubview:iconView];
        [iconView release];
    }
    
    [iconView setImageWithURL:[NSURL URLWithString:like.itemIconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    // 标题
    UILabel* titleLabel = (UILabel *)[cell.contentView viewWithTag:110];
    if ( !titleLabel ) {
        titleLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 10, 10,
                                            CGRectGetWidth(mainScreenBounds) - 15 * 2 - 10, 60),
                                 NSTextAlignmentLeft,
                              [UIColor blackColor],
                              [UIFont systemFontOfSize:14]);
        titleLabel.tag = 110;
        [cell.contentView addSubview:titleLabel];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    titleLabel.text = like.itemTitle;
    [titleLabel sizeToFit];
    
    // 价钱
    UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:120];
    if ( !priceLabel ) {
        priceLabel = createLabel(CGRectMake(CGRectGetMaxX(iconView.frame) + 10, 50,
                                            CGRectGetWidth(mainScreenBounds) - 15 * 2 - 10, 20),
                                 NSTextAlignmentLeft,
                                 GREEN_COLOR,
                                 [UIFont systemFontOfSize:14]);
        priceLabel.tag = 120;
        [cell.contentView addSubview:priceLabel];
    }
    
    priceLabel.text = [NSString stringWithFormat:@"%.2f", like.itemPrice];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Like* like = [self.dataSource objectAtIndex:indexPath.row];
    
    ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                from:self
                                                                                    toControllerName:@"ItemDetailViewController"]];
    Item* item = [[[Item alloc] init] autorelease];
    item.iid = like.itemId;
    aCommand.userData = item;
    
    [aCommand execute];
}

- (void)dealloc
{
    self.dataSource = nil;
    [super dealloc];
}

- (BOOL)shouldShowingCart { return NO; }


@end
