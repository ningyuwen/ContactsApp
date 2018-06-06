//
//  CollectionViewController.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/6/5.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "CollectionViewController.h"
#import "MyCollectionViewCell.h"
#import "AppUtil.h"

@interface CollectionViewController ()

@property (strong, nonatomic) UICollectionView *mainCollectionView;

@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"MyCollectionViewCell";

- (instancetype)init
{
    self = [super init];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 定义大小
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, 180);//[UIScreen mainScreen].bounds.size;
        // 设置垂直间距
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        return [self initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取数据
    _imgArray = [AppUtil loadEmployeeImgs];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = self.view.bounds;
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setAccessibilityIdentifier:@"collectionView"];
    [self.collectionView setIsAccessibilityElement:YES];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *name = [_imgArray objectAtIndex:indexPath.section * 2 + indexPath.row];
    [cell.headImageView setImage:[UIImage imageNamed:name]];
    cell.userNameLabel.text = name;
    
    return cell;
}

// 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath:%ld ", (long)indexPath.section);
    NSLog(@"row:%ld ", (long)indexPath.row);
    NSString *name = [_imgArray objectAtIndex:indexPath.section * 2 + indexPath.row];
    // 选择了图片跳转回上一页面，显示图片，发送广播，传递string字段就行
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getEmployeeImgSuccess" object:@{@"employeeName": name}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
