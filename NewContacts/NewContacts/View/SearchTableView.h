//
//  SearchTableView.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/25.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

@protocol SearchTableViewDelegate <NSObject>

- (void)callTelPhone:(Contacts *)contact;

// 关闭软键盘
- (void)closeInputKeyBoard;

@end

@interface SearchTableView : UITableView

- (void)setData:(NSString *)string;

// 数据
@property (strong, nonatomic) NSMutableArray *tableViewData;

@property (nonatomic, weak) id<SearchTableViewDelegate> searchViewDelegate;

@end
