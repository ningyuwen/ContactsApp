//
//  PictureChooseView.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/31.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureChooseDelegate <NSObject>

// 返回上一页
- (void)backToLastView;

@end

@interface PictureChooseView : UIStackView

@property (nonatomic, strong) NSMutableArray *imgArray;

@property (nonatomic, strong) id<PictureChooseDelegate> delegate;

- (void) initView;

@end
