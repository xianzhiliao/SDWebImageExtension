//
//  UIImageView+Category.h
//  UIImageView
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "UIImage+PTImageStyle.h"


@interface UIImageView(SizeFit)
/**
 *  图片需要处理的调用方法
 *
 *  @param url            url description
 *  @param placeholder    placeholder description
 *  @param options        options description
 *  @param progressBlock  progressBlock description
 *  @param completedBlock completedBlock description
 */
- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)sd_PTcategory_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
/**
 *  获取需要处理图片的当前url
 *
 *  @return 图片url
 */
- (NSURL *)sd_PTcategory_imageURL;
/**
 *  本地图片加载
 *
 *  @param name      图片名
 *  @param directory 绝对目录名
 */
- (void)sd_PTcategory_setLocalImageWithNamed:(NSString *)name inDirectory:(NSString*)directory;

@end
