//
//  MainActivityView.h
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

@protocol MainAcitivityViewDelegate <NSObject>

- (void)addContactsBtn:(UIButton *)button;
- (void)callTelPhone:(Contacts *)contact;
- (void)clickItem:(Contacts *)contact;
// 跳转搜索页面
- (void)enterSearchViewController;

@end

@interface MainActivityView : UIView

@property (nonatomic, weak) id<MainAcitivityViewDelegate> delegate;

- (void)reloadTableView;

@end
