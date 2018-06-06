//
//  UIImage+TextToImage.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/6/4.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TextToImage)

/**
 *  取颜色color背景图片
 *
 *  @param color color
 *  @param frame frame
 *
 *  @return UIImage
 */
+ (UIImage *)imageFormColor:(UIColor *)color frame:(CGRect)frame;


/**
 *  带居中文字的图片
 *
 *  @param title    文字
 *  @param fontSize 文字大小
 *
 *  @return UIImage
 */
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

@end
