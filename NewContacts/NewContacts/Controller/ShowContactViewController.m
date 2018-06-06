//
//  ShowContactViewController.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/24.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "ShowContactViewController.h"
#import "ShowContactView.h"
#import "AddOrEditContactsInfoViewController.h"
#import "AppUtil.h"

@interface ShowContactViewController ()

- (void)addShowContactView;

// 联系人页面
@property (nonatomic, retain) ShowContactView *showContactView;

@end

@implementation ShowContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [self addShowContactView];
    
    //注册广播接收器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationToRefreshView:) name:@"refreshShowContactView" object:nil];
}

// 接收通知刷新页面
- (void)receiveNotificationToRefreshView:(NSNotification *)notification{
    NSLog(@"1");
    [AppUtil getCurrentDate];
    
    _showContactView.contact = _contact;
    [_showContactView refreshView];
    
    NSLog(@"2");
    [AppUtil getCurrentDate];
}

// 跳转编辑页面
- (void)edit:(UIButton *)button{
    AddOrEditContactsInfoViewController *controller = [[AddOrEditContactsInfoViewController alloc] init];
    controller.contact = _contact;
    controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:YES];
}

// 添加显示联系人详情的页面
- (void)addShowContactView{
    _showContactView = [[ShowContactView alloc] init];
    _showContactView.contact = _contact;
    [_showContactView initUIView];
    [self.view addSubview:_showContactView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
//    if (animated == YES) {
//        _showContactView.contact = _contact;
//        [_showContactView refreshView];
//    }
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
