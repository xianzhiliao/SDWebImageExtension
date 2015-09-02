//
//  SDWebImageManager+Category.h
//  SDWebImageManager
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"


@interface SDWebImageManager(Category)

+ (SDWebImageManager *)sd_category_webImageManager;
+ (SDWebImageManager *)sd_category_localImageManager;
+ (void)clearCategoryImageCache;
+ (void)clearSharedImageCache;
+ (void)cleanCategoryDiskCache;
@end
