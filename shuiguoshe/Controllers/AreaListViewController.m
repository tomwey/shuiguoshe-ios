//
//  AreaListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "AreaListViewController.h"
#import "Defines.h"

NSString * const kAreaDidSelectNotification = @"kAreaDidSelectNotification";
NSString * const kAreaDidSelectNotification2Home = @"kAreaDidSelectNotification2Home";

@interface AreaListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end

@implementation AreaListViewController
{
    NSMutableArray* _dataSource;
    UITableView*    _tableView;
    NSMutableArray* _searchResults;
    NSArray*        _currentDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择小区或大学";
    
    if ( [[DataService sharedService] areaForLocal] ) {
        ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:
                                    [Forward buildForwardWithType:ForwardTypeDismiss
                                                             from:self
                                                     toController:nil]];
        
        [self setLeftBarButtonWithImage:@"btn_close.png" command:aCommand];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    CGRect frame = self.view.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:frame
                                              style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _searchResults = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    
    [[DataService sharedService] loadEntityForClass:@"Area"
                                                URI:@"/areas"
                                         completion:^(id result, BOOL succeed)
     {
        [_dataSource addObjectsFromArray:result];
         _currentDataSource = _dataSource;
         
         [_tableView reloadData];
     }];
    
    UIView* footer = [[[UIView alloc] init] autorelease];
    _tableView.tableFooterView = footer;
    
    UISearchBar* searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 44)] autorelease];
    searchBar.delegate = self;
    
    _tableView.tableHeaderView = searchBar;

    
}

- (BOOL)shouldShowingCart { return NO; }

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_tableView.tableHeaderView resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ( searchBar.text.length == 0 ) {
        _currentDataSource = _dataSource;
        [_tableView reloadData];
    } else {
        
        [_searchResults removeAllObjects];
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(Area* evaluatedObject, NSDictionary *bindings) {
            if( [evaluatedObject.name rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [evaluatedObject.address rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location != NSNotFound )
            {
                return YES;
            }
            return NO;
        }];
        
        NSArray* results = [_dataSource filteredArrayUsingPredicate:pred];
        
        [_searchResults addObjectsFromArray:results];
        
        _currentDataSource = _searchResults;
        [_tableView reloadData];
    }
}

- (void)dealloc
{
    [_dataSource release];
    [_searchResults release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell-%d", indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellId] autorelease];
    }
    
    Area* a = [_currentDataSource objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）", a.name, a.address];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( [[DataService sharedService] areaForLocal] ) {
        
        Area* a = [_currentDataSource objectAtIndex:indexPath.row];
        [[DataService sharedService] saveAreaToLocal:a];
        
        if ( [self.userData isEqualToString:@"Home"] ) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kAreaDidSelectNotification2Home object:nil];
        } else {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kAreaDidSelectNotification
             object:[_dataSource objectAtIndex:indexPath.row]];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        Area* a = [_currentDataSource objectAtIndex:indexPath.row];
        [[DataService sharedService] saveAreaToLocal:a];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kAreaDidSelectNotification2Home object:nil];
        
        ForwardCommand* aCommand =
        [ForwardCommand buildCommandWithForward:
         [Forward buildForwardWithType:ForwardTypePush
                                  from:self
                      toControllerName:@"HomeViewController"]];
        aCommand.userData = a;
        [aCommand execute];
    }
}


@end
