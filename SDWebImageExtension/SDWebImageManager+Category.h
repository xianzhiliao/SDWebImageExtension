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
/**
 *  web图片处理的SDWebImageManager
 *
 *  @return SDWebImageManager
 */
+ (SDWebImageManager *)sd_category_webImageManager;


@end
