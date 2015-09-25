//
//  SDImageCache+Category.h
//  SDImageCache
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "SDWebImageManager+PTManager.h"

@interface SDImageCache(PTCache)

/**
 *  所有经过处理的图片都会保存到这个缓存路径下
 *
 *  @return 处理过图片的缓存路径
 */
+ (SDImageCache *)sd_PTcategory_imageCache;

/**
 *  移除sd自带的内存缓存和磁盘缓存（会将磁盘缓存路径下的所有删除）
 */
- (void)clearSharedImageCache;
/**
 *  删除sd自带的磁盘缓存中所有过期的存储如果超过最大值的话还会从最旧的删除知道减半
 */
- (void)cleanSharedDiskCache;
/**
 *  移除自己扩展的存储处理过图片的所有缓存
 */
- (void)clearCategoryImageCache;
/**
 *  删除自己扩展的存储处理过图片的磁盘缓存中所有过期的存储如果超过最大值的话还会从最旧的删除知道减半
 */
- (void)cleanCategoryDiskCache;
/**
 *  sd所有的缓存空间(内存和磁盘)
 *  @return ***MB
 */
- (CGFloat)cacheSize;




/*
//最大内存设置（NSCache自动管理）（NSCache还有一个属性countLimit设置最多缓存数目）
 @property (assign, nonatomic) NSUInteger maxMemoryCost;
 
//最多保留日期一周（比如今天9.4会将8.28前的清掉）
@property (assign, nonatomic) NSInteger maxCacheAge;

//最大磁盘存储大小，默认没设置，不设置的话无限缓存，设置的话会判断如果当前缓存大于这个值会清到它的一半
@property (assign, nonatomic) NSUInteger maxCacheSize;

// 获取本地已经存储的大小
 - (NSUInteger)getSize;
 
// 获取本地磁盘存储的数目
- (NSUInteger)getDiskCount;
 
 //// clear 指的是移除所有本地缓存（直接删除了缓存路径）
 // clean 指的是移除过期的(一周 kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7;)
*/



@end
