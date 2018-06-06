//
//  AddOrEditContactsView.h
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

@protocol AddOrEditContactsDelegate <NSObject>

// 新增联系人
- (void)pushName:(NSString *)name andTelNumber:(NSString *)telNumber headImage:(UIImage *)image;

- (void)backToRootView;

// 删除联系人
- (void)deleteContact:(Contacts *)contact;

// 跳转系统相册
//- (void)jumpToUIImagePickerController;

// 返回上一页面
- (void)backToLastView;

// 选择相册
- (void)chooseImage;

@end

@interface AddOrEditContactsView : UIView

// 新建联系人
- (void)needNameAndTelNumber;
// 编辑联系人信息，需要把id传递回去替换之前的联系人信息
- (Contacts *)needContact;

// 初始化UI界面
- (void)initUIView;

- (void)replaceImage:(UIImage *)image;

- (UIImage *)getUserHeadImg;

@property (nonatomic, weak) id<AddOrEditContactsDelegate> delegate;
@property (nonatomic, assign) Contacts *contact;

@end
