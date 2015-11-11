//
//  SDWebImageManager+Category.h
//  SDWebImageManager
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "UIImage+PTImageStyle.h"

@interface SDWebImageManager(PTManager)<SDWebImageManagerDelegate>
/**
 *  web图片处理的SDWebImageManager
 *  @param PTImageFormater 图片格式
 *  @param isCacheOriginalImage 是否缓存原图
 *  @return SDWebImageManager
 */

- (instancetype) initWithPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage;
/*
 * 设置是否缓存原图
 */
- (void)setIsCacheOriginalImage:(BOOL)isCacheOriginalImage;
@end
