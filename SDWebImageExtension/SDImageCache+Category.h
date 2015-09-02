//
//  SDImageCache+Category.h
//  SDImageCache
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "SDWebImageManager+Category.h"

@interface SDImageCache(Category)

+ (SDImageCache *)sd_category_imageCache;
+ (SDImageCache *)sd_category_localImageCache;
@end
