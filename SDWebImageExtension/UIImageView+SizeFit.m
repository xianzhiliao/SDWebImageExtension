//
//  UIImageView+Category.m
//  UIImageView
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "UIImageView+SizeFit.h"
#import "SDImageCache+PTCache.h"
#include "UIView+WebCacheOperation.h"
#import "SDWebImageManager+PTManager.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"

static char imageURLKey;

@implementation UIImageView(SizeFit)

/**
 *  图片需要处理的调用方法
 *
 *  @param url            url description
 *  @param placeholder    placeholder description
 *  @param options        options description
 *  @param progressBlock  progressBlock description
 *  @param completedBlock completedBlock description
 */
- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options sdWebImageManager:(SDWebImageManager *)manager progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
{
    [self sd_cancelCurrentImageLoad];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
//    NSURL *formaterURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@formater",key]];
//    NSString *formaterkey = [[SDWebImageManager sharedManager] cacheKeyForURL:formaterURL];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak UIImageView *wself = self;
    if (!(options & SDWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            // placeholder不在这里处理(因此没有传图片类型)，直接在调用前处理，并且设置为static，因为placeholder都是一样的，没有必要浪费资源每次处理
            self.image = placeholder;
            [wself setNeedsLayout];
        });
    }
    if (url) {
        // 查询是否有缓存
        [[SDImageCache sd_PTcategory_imageCache]queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
            if (!wself) return;
            // 有缓存回调
            if (image) {
                dispatch_main_sync_safe(^{
                    wself.image = image;
                    [wself setNeedsLayout];
                });
                if (completedBlock) {
                    completedBlock(image, nil, cacheType, url);
                }
                return;
            }
            // 没缓存进行下载,在代理方法中处理图片,会自动将处理过的图片保存到sd_category_imageCache存储路径,如果需要原图保存到sharedImageCache,如果不需要保存原图，不保存
            else {
                __weak UIImageView *wself = self;
                id <SDWebImageOperation> operation = [manager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (!wself) return;
                    dispatch_main_sync_safe(^{
                        if (!wself) return;
                        if (image) {
                            wself.image = image;
                            [wself setNeedsLayout];
                        } else {
                            if ((options & SDWebImageDelayPlaceholder)) {
                                wself.image = placeholder;
                                [wself setNeedsLayout];
                            }
                        }
                        if (completedBlock && finished) {
                            completedBlock(image, error, cacheType, url);
                        }
                    });
                }];
                [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
            }
        }];
    }
    // url不存在
    else
    {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder sdWebImageManager:(SDWebImageManager *)manager completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_PTcategory_setImageWithURL:url placeholderImage:placeholder options:SDWebImageTransformAnimatedImage sdWebImageManager:manager progress:nil completed:completedBlock];
}

- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder sdWebImageManager:(SDWebImageManager *)manager
{
    [self sd_PTcategory_setImageWithURL:url placeholderImage:placeholder options:SDWebImageTransformAnimatedImage sdWebImageManager:manager progress:nil completed:nil];
}

/**
 *  获取需要处理图片的当前url
 *
 *  @return 图片url
 */
- (NSURL *)sd_PTcategory_imageURL
{
    return objc_getAssociatedObject(self, &imageURLKey);
}
/**
 *  本地图片加载
 *
 *  @param name      图片名
 *  @param directory 绝对目录名
 */
- (void)sd_PTcategory_setLocalImageWithNamed:(NSString *)name inDirectory:(NSString*)directory
{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:name]];
    // 从内存取
    UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:key];
    if (image) {
        dispatch_main_async_safe(^{
            self.image = image;
        });
        return;
    }
    // 没有的话从磁盘取
    // 图片存储路径
    NSString *prefixImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",directory]];
    NSInteger scale = [[UIScreen mainScreen]scale];
    if (scale != 3) {
        scale = 2;
    }
    NSString *fullPath = [prefixImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@%ldx.png",name,(long)scale]];
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    if (data) {
        UIImage *diskImage = [UIImage sd_imageWithData:data];
        diskImage = SDScaledImageForKey(key, diskImage);;
        if ([SDWebImageManager sharedManager].imageCache.shouldDecompressImages) {
            diskImage = [UIImage decodedImageWithImage:diskImage];
        }
        if (diskImage) {
            // 回显
            dispatch_main_async_safe(^{
                self.image = diskImage;
            });
            // 存内存
            CGFloat cost = diskImage.size.height * diskImage.size.width * diskImage.scale * diskImage.scale;
            [[[SDWebImageManager sharedManager].imageCache valueForKey:@"memCache"] setObject:diskImage forKey:key cost:cost];
        }
    }
}


@end
