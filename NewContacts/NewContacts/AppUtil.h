//
//  AppUtil.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/24.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contacts+CoreDataClass.h"
#import <UIKit/UIKit.h>

@interface AppUtil : NSObject

// 由于coredata不能方便的实现primary key，所以此处存储一个相当于sharedpreference的int值，用于保存当前ID最大值，用于新建联系人时添加ID字段
+ (NSInteger )ID;

+ (void)setID;

+ (void)updateContact:(Contacts *)contact;

// 获取所有联系人信息
+ (NSMutableArray *)loadContactsData;

// 删除联系人，传入contact
+ (void)deleteContact:(Contacts *)contact;

+ (NSMutableArray *)searchContact:(NSString *)string;

// 获取头像，根据用户id
+ (UIImage *)getImage:(Contacts *)contact;

// 打电话
+ (void)callTelPhone:(Contacts *)contact viewController:(UIViewController *)viewController;

// 获取时间戳
+ (void)getCurrentDate;

+ (NSMutableArray *)loadEmployeeImgs;

+ (void)addiOSEmployeeContacts;

+ (void)saveImage:(UIImage *)image userId:(int32_t) userId;

+ (NSMutableArray *)getContactsFromContactsAll;

// 新建联系人
+ (void)insertName:(NSString *)name andNumber:(NSString *)number headImage:(UIImage *)image;

@end
