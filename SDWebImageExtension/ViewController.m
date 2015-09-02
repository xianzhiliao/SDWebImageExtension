//
//  ViewController.m
//  SDWebImageExtension
//
//  Created by 廖贤志 on 15/8/30.
//  Copyright (c) 2015年 LXZ. All rights reserved.
//

#import "ViewController.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "MyTableViewCell.h"
#import "SDImageCache+Category.h"
#import "UIImageView+Category.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (nonatomic,strong)NSArray *arrayData;
typedef void(^SDDownLoadImageProcessBlock)();

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self requestImageFromLocal];
    
//    [SDWebImageManager clearCategoryImageCache];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"0" withExtension:@".png"];
    NSLog(@"url is %@",url);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init View

- (void)initTableView
{
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MyTableViewCell class])];
}

#pragma mark  end



#pragma mark - Delegate

/** 设置分区 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/** 每个分区上的元素个数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return 100;
    return  _arrayData.count;
}

/** 设置元素内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"MyTableViewCell";
    MyTableViewCell *cell = (MyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifer];
    NSString *imageUrl = _arrayData[indexPath.row];
    [SDWebImageManager sd_category_webImageManager].delegate = cell;
//    static UIImage *placeHolder;
//    placeHolder = [UIImage GLImage:[UIImage imageNamed:@"grape"] StyleRoundRect:(GLImageStyleRoundRectMake(cell.myImageView.frame.size.height / 4)) inImageView:cell.myImageView];
//    [cell.myImageView sd_category_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolder options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"prefixImages/0.png"];
    [cell.myImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:@"0.png"] andPlaceholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    return cell;
}


/** cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MyTableViewCellHeight;
}

/** cell点击事件 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MyTableViewCell *cell = (MyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark end



#pragma mark - Requset

- (void)requestImageFromLocal
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@".plist"];
    NSMutableArray *array1=[[NSMutableArray alloc] initWithContentsOfFile:sourcePath];
    _arrayData = [NSArray arrayWithArray:array1];
}

@end

