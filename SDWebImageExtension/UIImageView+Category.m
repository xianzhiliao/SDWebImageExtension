//
//  UIImageView+Category.m
//  UIImageView
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "UIImageView+Category.h"
#import "SDImageCache+Category.h"
#include "UIView+WebCacheOperation.h"
#import "SDWebImageManager+Category.h"
#import "SDWebImageDecoder.h"

static char imageURLKey;

@implementation UIImageView(Category)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)sd_category_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
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
        [[SDImageCache sd_category_imageCache]queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
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
                id <SDWebImageOperation> operation = [[SDWebImageManager sd_category_webImageManager] downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
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

#pragma clang diagnostic pop

- (NSURL *)sd_category_imageURL
{
    return objc_getAssociatedObject(self, &imageURLKey);
}






@end
