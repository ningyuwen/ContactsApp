//
//  MainTableView.h
//  Contacts
//  首页tableView，实现了分组功能
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"
#import "BMChineseSort.h"

@protocol MainTableViewDelegate

- (void)callTelPhone:(Contacts *)contact;
- (void)clickItem:(Contacts *)contact;

@end

@interface MainTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

//@property (retain, nonatomic) IBOutlet UITableView *tableView;

// 原始数据以及排好序之后的数据
@property (strong, nonatomic) NSMutableArray *tableDataArr;

// 按照字母分组的结果
@property (strong, nonatomic) NSMutableArray *indexArray;

@property (strong, nonatomic) id<MainTableViewDelegate> mainTableDelegate;

// 初始化时加载数据
- (void)loadData;


@end
