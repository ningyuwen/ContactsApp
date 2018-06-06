//
//  SearchViewController.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/25.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "SearchTableView.h"
#import "AppUtil.h"
#import "CallPhoneViewController.h"

@interface SearchViewController () <SearchViewDelegate, SearchTableViewDelegate>


- (void) initSearchBar;
- (void) initTableView;

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, retain) SearchTableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"搜索联系人"];
    [self initSearchBar];
    [self initTableView];
}

// 初始化搜索栏
- (void)initSearchBar{
    _searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height + 50, [UIScreen mainScreen].bounds.size.width, 60)];
    [self.view addSubview:_searchView];
    
    _searchView.searchViewdelegate = self;
    [_searchView becomeFirstResponder];
}

// 初始化tableview，搜索到结果的展示
- (void)initTableView{
    _tableView = [[SearchTableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 50 + 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - 110)];
    [self.view addSubview:_tableView];
    
    _tableView.searchViewDelegate = self;
}

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

// 跳转页面
- (void)callTelPhone:(Contacts *)contact{
//    CallPhoneViewController *controller = [[CallPhoneViewController alloc]init];
//    controller.contact = contact;
//    controller.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:controller animated:YES];
    [AppUtil callTelPhone:contact viewController:self];
}

// 根据用户输入的文字，搜索
- (void)searchDataFromString:(NSString *)string{
    // 搜索字段为空，则显示所有用户信息
    if ([string isEqualToString:@""]) {
        _tableView.tableViewData = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).contactData.contactDataArray;
        [_tableView reloadData];
        return;
    }
    // 搜索字段不为空
    NSMutableArray *resultArray = [AppUtil searchContact:string];
    _tableView.tableViewData = nil;
    _tableView.tableViewData = resultArray;
    [_tableView reloadData];
}

- (void)closeInputKeyBoard{
    [_searchView resignFirstResponder];
}

@end
