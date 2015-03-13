//
//  NewMessageViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NewMessageViewController.h"
#import "Defines.h"

@interface NewMessageViewController () <UITextViewDelegate>

@end

@implementation NewMessageViewController
{
    UILabel* _tipLabel;
    UITextField* _titleField;
    UITextView*  _bodyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我有话说";
    
    UITextField* titleField = [[UITextField alloc] initWithFrame:
                               CGRectMake(15, 80,
                                          CGRectGetWidth(mainScreenBounds) - 30,
                                                                            30)];
    [self.view addSubview:titleField];
    [titleField release];
    
    titleField.borderStyle = UITextBorderStyleRoundedRect;
    
    titleField.font = [UIFont systemFontOfSize:16];
    titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titleField.placeholder = @"输入标题，必须";
    
    _titleField = titleField;
    
    // 内容
    CGRect frame = titleField.frame;
    frame.origin.y = CGRectGetMaxY(frame) + 6;
//    frame.origin.x = 12;
    frame.size.height = 100;
    
    UITextView* bodyView = [[UITextView alloc] initWithFrame:frame];
    bodyView.delegate = self;
    [self.view addSubview:bodyView];
    [bodyView release];
    
    bodyView.layer.cornerRadius = 5;
    bodyView.layer.borderColor = [RGB(224, 224, 224) CGColor];
    bodyView.layer.borderWidth = 1.0;
    bodyView.layer.masksToBounds = YES;
    
    _bodyView = bodyView;
    
    bodyView.font = [UIFont systemFontOfSize:16];
//    bodyView.text = @"输入内容...";
    
    frame = titleField.frame;
    frame.origin.y = CGRectGetMaxY(frame) + 8;
    frame.origin.x = 22;
    
    _tipLabel = createLabel(frame,
                                      NSTextAlignmentLeft,
                                      RGB(207, 207, 207),
                                      [UIFont systemFontOfSize:16]);
    _tipLabel.text = @"输入内容，必须";
    [self.view addSubview:_tipLabel];
    
    UIButton* commitBtn = [[CoordinatorController sharedInstance] createTextButton:@"提交"
                                                                              font:[UIFont systemFontOfSize:14]
                                                                        titleColor:COMMON_TEXT_COLOR
                                                                           command:nil];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:commitBtn] autorelease];
}

- (void)commit
{
    if ( [[_titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [Toast showText:@"标题必须为非空"];
        return;
    }
    
    if ( [[_bodyView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 ) {
        [Toast showText:@"内容必须为非空"];
        return;
    }
    
    [[DataService sharedService] post:@"/messages" params:@{ @"token": [[UserService sharedService] token],
                                                             @"title": [_titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                                             @"body": [_bodyView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]}
                           completion:^(NetworkResponse* resp)
    {
       if ( !resp.requestSuccess ) {
           [Toast showText:@"呃，系统出错了"];
       } else {
           if ( resp.statusCode == 0 ) {
               [Toast showText:@"留言成功"];
               [self.navigationController popViewControllerAnimated:YES];
           } else {
               [Toast showText:@"留言失败"];
           }
       }
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( textView.text.length > 0 ) {
        _tipLabel.hidden = YES;
    } else {
        _tipLabel.hidden = NO;
    }
}

- (BOOL)shouldShowingCart { return NO; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
