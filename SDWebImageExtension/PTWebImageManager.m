//
//  PTWebImageManager.m
//  SDWebImageExtension
//
//  Created by xianzhiliao on 15/11/11.
//  Copyright © 2015年 LXZ. All rights reserved.
//

#import "PTWebImageManager.h"
#import "SDImageCache+PTCache.h"
#import "SDImageCache.h"

@interface PTWebImageManager()<SDWebImageManagerDelegate>

@property (nonatomic, assign) PTImageFormater ptImageFormater;
@property (nonatomic, assign) BOOL isCache;


@end

@implementation PTWebImageManager


- (void)setIsCacheOriginalImage:(BOOL)isCacheOriginalImage
{
    self.isCache = isCacheOriginalImage;
}
- (instancetype)initWithPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage
{
    self = [super init];
    if (self) {
        [self setValue:[SDImageCache sd_PTcategory_imageCache]forKey:@"imageCache"];
        self.delegate = self;
        self.ptImageFormater = ptImageFormater;
        self.isCache = isCacheOriginalImage;
    }
    return self;
}
#pragma mark - SDWebImageManagerDelegate

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    // 处理图片,返回处理过的图片会自动保存到sd_category_imageCache存储路径,如果需要原图保存到sharedImageCache,如果不需要保存原图，不保存
    UIImage *formaterImage = [image imageWithPTImageFormater:self.ptImageFormater];
    // 需要的话将原图片保存
    if (self.isCache) {
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
        [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key];
    }
    // 返回处理过的图片
    return formaterImage;
}
@end
