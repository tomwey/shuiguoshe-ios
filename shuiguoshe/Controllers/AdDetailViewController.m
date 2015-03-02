//
//  AdDetailViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-2.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "AdDetailViewController.h"
#import "Defines.h"

@interface AdDetailViewController () <UIWebViewDelegate>

@end

@implementation AdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Banner* banner = self.userData;
    
    if ( banner.title.length == 0 ) {
        self.title = @"水果社广告";
    } else {
        self.title = banner.title;
    }
    
    UIWebView* adView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:adView];
    [adView release];
    
    adView.delegate = self;
    
    adView.scalesPageToFit = YES;
    
    [adView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:banner.link]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL)shouldShowingCart { return NO; };

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
