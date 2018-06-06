//
//  Toast.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/28.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : UIView

+ (Toast *)makeText:(NSString *)text;

- (void)show;

@end
