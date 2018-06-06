//
//  Toast.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/28.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "Toast.h"


@interface Toast()

// 文本框
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation Toast

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (Toast *)makeText:(NSString *)text{
    static Toast *toast = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        toast = [[self alloc] init];
        toast.titleLabel = [[UILabel alloc] init];
        toast.titleLabel.textColor=[UIColor whiteColor];
        toast.titleLabel.textAlignment = NSTextAlignmentCenter;
        toast.titleLabel.layer.masksToBounds = YES;
        toast.titleLabel.numberOfLines = 0;
        toast.titleLabel.layer.cornerRadius = 15;
        toast.titleLabel.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.75f];
    });
    CGSize size=[text boundingRectWithSize:CGSizeMake(250*1, 100*1) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*1]} context:nil].size;
    toast.titleLabel.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width-30*1)/2, [UIScreen mainScreen].bounds.size.height - 50*1-size.height, size.width+30*1, size.height+10*1);
    toast.titleLabel.text=text;
    return toast;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:_titleLabel];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_titleLabel];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^{
        self->_titleLabel.alpha = 0;
    } completion:^(BOOL finished){
        self->_titleLabel.alpha = 1;
        [self->_titleLabel removeFromSuperview];
    }];
    
}

@end
