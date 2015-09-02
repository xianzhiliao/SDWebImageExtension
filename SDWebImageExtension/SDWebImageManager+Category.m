//
//  SDWebImageManager+Category.m
//  SDWebImageManager
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "SDImageCache+Category.h"
#import "SDImageCache.h"


@implementation SDWebImageManager(Category)
/**
 *  web图片处理的SDWebImageManager
 *
 *  @return SDWebImageManager
 */
+ (SDWebImageManager *)sd_category_webImageManager
{
    static dispatch_once_t once;
    static SDWebImageManager *instance;
    dispatch_once(&once, ^{
        instance = [[SDWebImageManager alloc]init];
        [instance setValue:[SDImageCache sd_category_imageCache]forKey:@"imageCache"];
    });
    return instance;
}
/**
 *  本地图片处理的SDWebImageManager
 *
 *  @return SDWebImageManager
 */
+ (SDWebImageManager *)sd_category_localImageManager
{
    static dispatch_once_t once;
    static SDWebImageManager *instance;
    dispatch_once(&once, ^{
        instance = [[SDWebImageManager alloc]init];
        [instance setValue:[SDImageCache sd_category_localImageCache]forKey:@"imageCache"];
    });
    return instance;
}
// clear 指的是移除所有缓存
// clean 指的是移除过期的(一周 kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7;)
+ (void)clearSharedImageCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}
+ (void)clearCategoryImageCache
{
    [[SDWebImageManager sd_category_webImageManager].imageCache clearMemory];
    
    [[SDWebImageManager sd_category_webImageManager].imageCache clearDisk];
}

+ (void)cleanCategoryDiskCache
{
    [[SDWebImageManager sd_category_webImageManager].imageCache cleanDisk];
}

@end
