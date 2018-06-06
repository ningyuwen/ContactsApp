//
//  MainActivityView.m
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "MainActivityView.h"
#import "MainTableView.h"

@interface MainActivityView() <MainTableViewDelegate>{
    int _screenWidth;
    int _statusBarHeight;
    int _screenHeight;
    int _navigationBarHeight;
    int _searchBarHeight;
}

@property (nonatomic, strong, nullable) UIButton *button;
@property (nonatomic, strong) MainTableView *tableView;

@end

@implementation MainActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _screenWidth = [[UIScreen mainScreen]bounds].size.width;
        _statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        _screenHeight = [[UIScreen mainScreen]bounds].size.height;
        _navigationBarHeight = 50;
        _searchBarHeight = 60;
        
        [self initSearchBar];
        [self initContactsTableView];
//        [self initAddContactsBtn];
    }
    return self;
}

// 重新加载数据,暂时全部刷新
- (void)reloadTableView{
    [_tableView loadData];
    [_tableView reloadData];
    
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.tableView.numberOfSections - 1];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

// 初始化主页的tableView
- (void)initContactsTableView{
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self->statusBarHeight + self->navigationBarHeight + self->searchBarHeight, self->screenWidth, self->screenHeight) style:UITableViewStylePlain];
//    [self addSubview:self.tableView];
    
    _tableView = [[MainTableView alloc]initWithFrame:CGRectMake(0, _statusBarHeight + _navigationBarHeight + _searchBarHeight, _screenWidth, _screenHeight - _statusBarHeight - _navigationBarHeight - _searchBarHeight)];
    [self addSubview:_tableView];
    
    //代理
    _tableView.mainTableDelegate = self;
}

// cell中的点击事件（拨打电话）回调到此处，再回传到controller，进行携带数据进行页面跳转
- (void)callTelPhone:(Contacts *)contact{
    NSLog(@"callTelPhone:: %@, %@", contact.name, contact.number);
    [_delegate callTelPhone:contact];
}

//初始化搜索框
- (void)initSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, _statusBarHeight + _navigationBarHeight, _screenWidth, _searchBarHeight)];
    [searchBar setPlaceholder:@"Search"];
    searchBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:searchBar];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, _statusBarHeight + _navigationBarHeight, _screenWidth, _searchBarHeight)];
    [button addTarget:self action:@selector(searchBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

// searchBar下面加了一个button，点击跳转
- (void)searchBarClick:(UIButton *)btn{
    [_delegate enterSearchViewController];
}

//初始化添加按钮
- (void)initAddContactsBtn{
    _button = [[UIButton alloc]init];
    [_button setFrame:CGRectMake(_screenWidth - _navigationBarHeight, _statusBarHeight, _navigationBarHeight, _navigationBarHeight - 10)];
    [_button setTitle:@"+" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:28.0];
    [self addSubview:_button];
    [_button addTarget:self action:@selector(addContactsBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addContactsBtn:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(addContactsBtn:)]) {
        [_delegate addContactsBtn:_button];
    }
}

// MainTableView中cell的点击事件传递到此处，再传递到controller处理，跳转页面
- (void)clickItem:(Contacts *)contact{
    [_delegate clickItem:contact];
}

@end
