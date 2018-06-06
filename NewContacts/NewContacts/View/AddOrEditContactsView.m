//
//  AddOrEditContactsView.m
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "AddOrEditContactsView.h"
#import "AppUtil.h"
#import "Toast.h"
#import "InputNumberTextField.h"
#import "UIImage+TextToImage.h"

@interface AddOrEditContactsView() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InputNumberDelegate>

- (void)addTextFieldOfName;
- (void)addTextFieldOfTelNumber;
- (void)addUserHeadImgView;

- (void)deleteContact:(UIButton *)button;
- (void)addDeleteContactBtn;

@property (nonatomic, strong) UITextField *textFieldOfName;
@property (nonatomic, strong) UITextField *textFieldOfTelNumber;
@property (nonatomic, strong) UIImageView *userHeadImgView;
@property (nonatomic, strong) NSString *nameStr;    //输入姓名的首个字符

@end

@implementation AddOrEditContactsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
//    if (self) {
//        [self addTextFieldOfName];
//        [self addTextFieldOfTelNumber];
//    }
    return self;
}

// 初始化UI界面
- (void)initUIView{
    [self addTextFieldOfName];
    [self addTextFieldOfTelNumber];
    [self addDeleteContactBtn];
    [self addUserHeadImgView];
}

// 由外部调用，告知需要获取数据，从此处传过去，暂时是添加联系人的代码
- (void)needNameAndTelNumber{
    [_delegate pushName:_textFieldOfName.text andTelNumber:_textFieldOfTelNumber.text headImage:_userHeadImgView.image];
}

// 编辑联系人信息，需要把id传递回去替换之前的联系人信息，这是编辑联系人的代码，以后有机会合并
- (Contacts *)needContact{
    _contact.name = _textFieldOfName.text;
    _contact.number = _textFieldOfTelNumber.text;
    return _contact;
}

// 添加姓名输入框
- (void)addTextFieldOfName{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"姓名"];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setFrame:CGRectMake(50, 260, [[UIScreen mainScreen] bounds].size.width - 100, 30)];
    [self addSubview:label];
    
    _textFieldOfName = [[UITextField alloc] initWithFrame:CGRectMake(50, 270, [[UIScreen mainScreen] bounds].size.width - 100, 60)];
    [_textFieldOfName becomeFirstResponder];
    [_textFieldOfName setReturnKeyType:UIReturnKeyDone];
    _textFieldOfName.delegate = self;
    [self addSubview:_textFieldOfName];
    
    // 监听文字改变
    [_textFieldOfName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    UITapGestureRecognizer *singtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBoard)];
//    [_textFieldOfName addGestureRecognizer:singtap];
    
    _textFieldOfName.tintColor = [UIColor grayColor];
    _textFieldOfName.textColor = [UIColor blueColor];
    //判断是否是编辑
    if (_contact == nil) {
        _textFieldOfName.placeholder = @"Name";
    }else{
        _textFieldOfName.text = _contact.name;
    }
    [self addSubview:_textFieldOfName];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 320, [[UIScreen mainScreen] bounds].size.width - 100, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textFieldOfName resignFirstResponder];
    return YES;
}


// 添加手机号码输入框
- (void)addTextFieldOfTelNumber{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"号码"];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setFrame:CGRectMake(50, 340, [[UIScreen mainScreen] bounds].size.width - 100, 30)];
    [self addSubview:label];
    
    _textFieldOfTelNumber = [[InputNumberTextField alloc] initWithFrame:CGRectMake(50, 350, [[UIScreen mainScreen] bounds].size.width - 100, 60)];
    [_textFieldOfTelNumber setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_textFieldOfTelNumber];
    _textFieldOfTelNumber.inputDelegate = self;
    
    _textFieldOfTelNumber.tintColor = [UIColor grayColor];
    _textFieldOfTelNumber.textColor = [UIColor blueColor];
    _textFieldOfTelNumber.keyboardType = UIKeyboardTypeNumberPad;
    //判断是否是编辑
    if (_contact == nil) {
        _textFieldOfTelNumber.placeholder = @"TelNumber";
    }else{
        _textFieldOfTelNumber.text = _contact.number;
    }
    [self addSubview:_textFieldOfTelNumber];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 400, [[UIScreen mainScreen] bounds].size.width - 100, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}

// 删除联系人,只在edit按钮之后出现，删除之后需要修改coredata、内存缓存中的数据
- (void)deleteContact:(UIButton *)button{
    //删除
    [_delegate deleteContact:_contact];
    
    //返回上一页面
    [_delegate backToRootView];
}

// 添加删除联系人按钮,此联系人信息是一个全局变量保存在contact中，方便获取
- (void)addDeleteContactBtn{
    if (_contact == nil) {
        return;
    }
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 150, [UIScreen mainScreen].bounds.size.width - 40, 70)];
    [button setTitle:@"删除此联系人" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(deleteContact:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

// 添加用户头像
- (void)addUserHeadImgView{
    _userHeadImgView = [[UIImageView alloc] init];
    [_userHeadImgView setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 60, 120, 120, 120)];
    _userHeadImgView.layer.cornerRadius = _userHeadImgView.frame.size.width / 2;
    _userHeadImgView.layer.masksToBounds = YES;
    [_userHeadImgView.layer setBorderWidth:0.5];
    [_userHeadImgView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    // 判断是新建联系人还是编辑联系人
    UIImage *img = nil;
    if (_contact == nil) {
        // 新建
        img = [UIImage imageNamed:@"black.png"];
    }else{
        img = [AppUtil getImage:_contact];
    }
    [_userHeadImgView setImage:img];
    [self addSubview:_userHeadImgView];
    
    _userHeadImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_userHeadImgView addGestureRecognizer:singleTap];
}

// 为imageview添加点击事件
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    //do something....
    [_delegate chooseImage];
}

// 选择系统相册中的图片，done保存的时候存储uiimage对象到本地沙盒
// 若没有选择图片，则保存默认的图片路径
- (void)replaceImage:(UIImage *)image{
    [_userHeadImgView setImage:image];
}

- (UIImage *)getUserHeadImg{
    return [_userHeadImgView image];
}

- (void)transViewUp:(NSNotification *)aNSNotification{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds=[[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect=[keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    NSLog(@"看看这个变化的Y值:%f",deltaY);
    
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+deltaY, self.frame.size.width, self.frame.size.height)];
    }];
}

// 获取输入的姓名文字的改变
- (void)textFieldDidChange:(id) sender {
    if (_contact != nil) {
        return;
    }
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length == 0) {
        // 修改成空白的图片
        _nameStr = @"";
        [self replaceImage:[UIImage imageNamed:@"black.png"]];
        return;
    }
    NSString *str = [_field.text substringToIndex:1];
    if (_nameStr == nil) {
        _nameStr = str;
        // 更换图片
        [self changeHeadTextImage:_nameStr];
    }else{
        if ([_nameStr isEqualToString:str]) {
            return;
        }
        // 不为空，且不相等，更换文字，更换图片
        _nameStr = str;
        // 更换图片
        [self changeHeadTextImage:_nameStr];
    }
}

// 修改为文字头像
- (void)changeHeadTextImage:(NSString *)text{
//    UIImageView *_imageView=[[UIImageView alloc]init];
//    [_imageView setCenter:_userHeadImgView.center];
//    [_imageView setBounds:CGRectMake(0.0, 0.0, 50.0, 50.0)];
//    [_imageView.layer setCornerRadius:25.0];
//    [_imageView.layer setMasksToBounds:YES];
//    [_imageView setBackgroundColor:[UIColor colorWithRed:254.0/255 green:52.0/255 blue:134.0/255 alpha:1.0]];
//    [_imageView setImage:[[UIImage imageFormColor:[UIColor colorWithRed:254.0/255 green:52.0/255 blue:134.0/255 alpha:1.0] frame:_imageView.bounds] imageWithTitle:text fontSize:14.0]];
//    //    [_imageView setImage:[[TextToImageView imageFormColor:[UIColor colorWithRed:200.0/255 green:0.7 blue:0.6 alpha:1.0] frame:_imageView.bounds] imagewithtitle]
//    [self addSubview:_imageView];
    
    UIImage *image = [[UIImage imageFormColor:[UIColor colorWithRed:40.0/255 green:43.0/255 blue:53.0/255 alpha:1.0] frame:_userHeadImgView.bounds] imageWithTitle:text fontSize:36.0];
    [self replaceImage:image];
}

@end
