//
//  PictureChooseView.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/31.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "PictureChooseView.h"
#import "AppUtil.h"
#import <objc/runtime.h>

@implementation PictureChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlignment:UIStackViewAlignmentLeading];
        [self setDistribution:UIStackViewDistributionFillProportionally];
//        [self setSpacing:10];
        [self setAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

- (void)initView{
    _imgArray = [AppUtil loadEmployeeImgs];
    [self addHorizontalStackView:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 1200) position:YES];
    [self addHorizontalStackView:CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 0, [UIScreen mainScreen].bounds.size.width / 2, 1200) position:NO];
}

- (void)addHorizontalStackView:(CGRect)cgRect position:(BOOL)left{
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:cgRect];
    [stackView setAlignment:UIStackViewAlignmentLeading];
    [stackView setDistribution:UIStackViewDistributionFillProportionally];
    [stackView setSpacing:10];
    [stackView setAxis:UILayoutConstraintAxisVertical];
    
    if (left) {
        for (int i = 0; i < 6; i++) {
            [stackView addArrangedSubview:[self addImageView:[_imgArray objectAtIndex:i]]];
        }
    }else{
        for (int i = 6; i < _imgArray.count; i++) {
            [stackView addArrangedSubview:[self addImageView:[_imgArray objectAtIndex:i]]];
        }
    }
    
    [self addArrangedSubview:stackView];
}

- (UIImageView *)addImageView:(NSString *)imgPath{
    UIImage *image = [UIImage imageNamed:((void)((@"%@.png")), imgPath)];
    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 200)];
//    [imageView.layer setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 200)];
//    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
//    imageView.layer.masksToBounds = YES;
    [imageView.layer setBorderWidth:0.5];
    [imageView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [imageView setImage:image];
    
    // 设置点击事件
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [imageView addGestureRecognizer:singleTap];
    objc_setAssociatedObject(singleTap, @"click_img", imgPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return imageView;
}

// 为imageview添加点击事件，需要传递点击位置过来
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    //do something....
    NSString *string =  objc_getAssociatedObject(gestureRecognizer, @"click_img");
    NSLog(@"%@", string);
    
    // 选择了图片跳转回上一页面，显示图片，发送广播，传递string字段就行
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getEmployeeImgSuccess" object:@{@"employeeName": string}];
    [_delegate backToLastView];
}

@end
