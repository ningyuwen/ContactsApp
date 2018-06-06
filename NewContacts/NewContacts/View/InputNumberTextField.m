//
//  InputNumberTextField.m
//  NewContacts
//  只输入数字的textfield，用于输入用户号码
//  Created by 宁玉文 on 2018/5/30.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "InputNumberTextField.h"

@implementation InputNumberTextField

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
        self.delegate = self;
        //注册观察键盘的变化
        [self addTarget:self action:@selector(setClickListener:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setClickListener:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}

//移动UIView
- (void)transformView:(NSNotification *)aNSNotification{
    [self.inputDelegate transViewUp:aNSNotification];
}

@end
