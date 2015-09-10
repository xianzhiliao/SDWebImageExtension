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
    [self initNav];
    [self initTableView];
    [self requestImageFromLocal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init View
/* 设置导航栏上面的内容 */
- (void)initNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:[SDImageCache sharedImageCache] action:@selector(clearCategoryImageCache)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清理" style:UIBarButtonItemStylePlain target:[SDImageCache sd_PTcategory_imageCache] action:@selector(cleanCategoryDiskCache)];
}
/*  初始化tableview */
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
    [SDWebImageManager sd_PTcategory_webImageManager].delegate = cell;
    // 设置为static，因为placeholder都是一样的，没有必要浪费资源每次处理
    static dispatch_once_t once;
    static UIImage *placeHolder = nil;
    dispatch_once(&once, ^{
        if (placeHolder == nil) {
            placeHolder = [UIImage GLImage:[UIImage imageNamed:@"grape"] StyleRoundRect:(GLImageStyleRoundRectMake(cell.myImageView.frame.size.height / 4)) inImageView:cell.myImageView];
        }
    });
    [cell.myImageView sd_PTcategory_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolder options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
//    [cell.myImageView sd_PTcategory_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolder];
    
    // 本地图片加载用sd自带的,在AppDelegate中添加了只读缓存路径，会从中读取(弊端就是图片名字全部要用md5加密过后的)
//    [cell.myImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:@"0.png"] andPlaceholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
    
    // 自己写的本地图片加载,完全抄袭sd,把图片名字换成了明文而已
//    [cell.myImageView sd_category_setLocalImageWithNamed:@"putao_icon_quick_jk_s"inDirectory:@"prefixImages"];
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

