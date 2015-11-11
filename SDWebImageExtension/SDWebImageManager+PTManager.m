//
//  SDWebImageManager+Category.m
//  SDWebImageManager
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "SDImageCache+PTCache.h"
#import "SDImageCache.h"


static PTImageFormater imageFormater;
static BOOL isCache;
@implementation SDWebImageManager(PTManager)

- (void)setIsCacheOriginalImage:(BOOL)isCacheOriginalImage
{
    isCache = isCacheOriginalImage;
}
- (instancetype)initWithPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage
{
    SDWebImageManager *instance = [[SDWebImageManager alloc]init];
    if (instance) {
        [instance setValue:[SDImageCache sd_PTcategory_imageCache]forKey:@"imageCache"];
        instance.delegate = instance;
    }
    imageFormater = ptImageFormater;
    isCache = isCacheOriginalImage;
    return instance;
}
#pragma mark - SDWebImageManagerDelegate

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    // 处理图片,返回处理过的图片会自动保存到sd_category_imageCache存储路径,如果需要原图保存到sharedImageCache,如果不需要保存原图，不保存
    UIImage *formaterImage = [image imageWithPTImageFormater:imageFormater];
    // 需要的话将原图片保存
    if (isCache) {
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
        [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key];
    }
    // 返回处理过的图片
    return formaterImage;
}

#pragma mark end
@end
