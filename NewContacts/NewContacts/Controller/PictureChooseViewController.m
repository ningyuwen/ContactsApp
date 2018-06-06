//
//  PictureChooseViewController.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/31.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "PictureChooseViewController.h"
#import "PictureChooseView.h"

@interface PictureChooseViewController () <PictureChooseDelegate>

@property (nonatomic, strong) PictureChooseView *pictureChooseView;

@end

@implementation PictureChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"员工相册";
    
    [self initChoosePictureView];
    _pictureChooseView.delegate = self;
}

- (void)initChoosePictureView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _pictureChooseView = [[PictureChooseView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1200)];
//    _pictureChooseView = [[PictureChooseView alloc] init];
    [_pictureChooseView initView];
    [scrollView addSubview:_pictureChooseView];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1260)];
}

- (void)loadView{
    [super loadView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToLastView{
    [self.navigationController popViewControllerAnimated:YES];
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
