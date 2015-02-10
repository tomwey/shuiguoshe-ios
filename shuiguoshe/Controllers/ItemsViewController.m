//
//  ItemsViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "ItemsViewController.h"

@interface ItemsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ItemsViewController
{
    NSArray* _dataSource;
    int      _numberOfCols;
}

- (void)dealloc
{
    self.catalog = nil;
    [_dataSource release];
    
    [super dealloc];
}

- (BOOL)shouldShowingCart { return YES; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.catalog.name;
    
    [self setLeftBarButtonWithImage:@"btn_back.png"
                             target:self
                             action:@selector(back)];
    
    _numberOfCols = 2;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),
                                                                           CGRectGetHeight(mainScreenBounds))
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    tableView.delegate   = self;
    
    tableView.rowHeight = 240;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [[DataService sharedService] loadEntityForClass:@"Item"
                                                URI:[NSString stringWithFormat:@"/items/type-%ld", self.catalog.cid]
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 [_dataSource release];
                                                 _dataSource = [[NSArray alloc] initWithArray:result];
                                                 [tableView reloadData];
                                             } else {
                                                 
                                             }
                                         }];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self totalRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell%ld", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self addItemViewForCell:cell atIndex: indexPath.row];
    
    return cell;
}

- (NSInteger)totalRows
{
    return ( [_dataSource count] + _numberOfCols - 1 ) / _numberOfCols;
}

- (void)addItemViewForCell:(UITableViewCell *)cell atIndex:(NSInteger)row
{
    NSInteger colCount = _numberOfCols;
    if ( [self totalRows] - 1 == row ) {
        colCount = [_dataSource count] - row * _numberOfCols;
    }
    
    CGFloat padding = 20;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - _numberOfCols * padding - padding / 2 ) / _numberOfCols;
    
    __block ItemsViewController* me = self;
    
    for (int i=0; i<colCount; i++) {
        NSInteger index = row * _numberOfCols + i;
        
        ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:100 + index];
        if ( !itemView ) {
            itemView = [[[ItemView alloc] init] autorelease];
            itemView.tag = 100 + index;
            [cell.contentView addSubview:itemView];
        }
        
        itemView.item = [_dataSource objectAtIndex:index];
        
        itemView.didSelectBlock = ^(ItemView *itemView) {
            ItemDetailViewController* idvc = [[ItemDetailViewController alloc] init];
            idvc.item = itemView.item;
            [me.navigationController pushViewController:idvc animated:YES];
            [idvc release];
        };
        
        itemView.frame = CGRectMake(padding + (width + padding/2) * i,
                                    10, width, 230);
    }
}

@end
