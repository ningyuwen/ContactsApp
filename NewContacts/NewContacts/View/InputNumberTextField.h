//
//  InputNumberTextField.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/30.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputNumberDelegate <NSObject>

- (void)transViewUp:(NSNotification *)aNSNotification;

@end

@interface InputNumberTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, strong) id<InputNumberDelegate> inputDelegate;

@end
