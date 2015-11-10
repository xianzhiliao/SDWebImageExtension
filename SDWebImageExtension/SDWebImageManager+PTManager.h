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
 *
 *  @return SDWebImageManager
 */
+ (SDWebImageManager *)sd_PTcategory_webImageManager;

//- (instancetype) initWithPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage;
- (void)setPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage;
@end
