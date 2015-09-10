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
+ (SDWebImageManager *)sd_PTcategory_webImageManager
{
    static dispatch_once_t once;
    static SDWebImageManager *instance;
    dispatch_once(&once, ^{
        instance = [[SDWebImageManager alloc]init];
        [instance setValue:[SDImageCache sd_PTcategory_imageCache]forKey:@"imageCache"];
    });
    return instance;
}



@end
