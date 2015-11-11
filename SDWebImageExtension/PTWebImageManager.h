//
//  PTWebImageManager.h
//  SDWebImageExtension
//
//  Created by xianzhiliao on 15/11/11.
//  Copyright © 2015年 LXZ. All rights reserved.
//

#import "SDWebImageManager.h"
#import "UIImage+PTImageStyle.h"

@interface PTWebImageManager : SDWebImageManager
- (instancetype) initWithPTImageFormater:(PTImageFormater)ptImageFormater isCacheOriginalImage:(BOOL)isCacheOriginalImage;
/*
 * 设置是否缓存原图
 */
- (void)setIsCacheOriginalImage:(BOOL)isCacheOriginalImage;
@end
