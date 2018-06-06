//
//  CallPhoneViewController.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/23.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "CallPhoneViewController.h"

@interface CallPhoneViewController ()

@end

@implementation CallPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Call";
    
    [self addUILabel];
}

- (void)addUILabel{
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    [label setText:[NSString stringWithFormat:@"拨打电话 %@, %@", _contact.name, _contact.number]];
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
