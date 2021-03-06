//
//  UIImageView+Category.m
//  UIImageView
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "SDImageCache+PTCache.h"
#import "SDImageCache.h"


@implementation SDImageCache(PTCache)

/**
 *  所有经过处理的图片都会保存到这个缓存路径下
 *
 *  @return 处理过图片的缓存路径
 */
+ (SDImageCache *)sd_PTcategory_imageCache
{
    static dispatch_once_t once;
    static SDImageCache *instance;
    dispatch_once(&once, ^{
        instance = [[SDImageCache alloc]initWithNamespace:@"formater"];
        // 字节数 byte (KB = 1024byte)
//        instance.maxCacheSize = 8 * 1024 * 60;//30KB左右的图片可以存15张左右，达到这个值清理后会只留一半差不多7张左右
    });
    return instance;
}

// clear 指的是移除所有缓存
// clean 指的是移除过期的(一周 kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7;)并且如果设置了maxSize会超出的话会清到一半
/**
 *  移除sd自带的内存缓存和磁盘缓存（会将磁盘缓存路径下的所有删除）
 */
- (void)clearSharedImageCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    
    [SDWebImageManager.sharedManager.imageCache clearDisk];
    
}
/**
 *  删除sd自带的磁盘缓存中所有过期的存储如果超过最大值的话还会从最旧的删除知道减半
 */
- (void)cleanSharedDiskCache
{
    [[SDWebImageManager sharedManager].imageCache cleanDisk];
}
/**
 *  移除自己扩展的存储处理过图片的所有缓存
 */
- (void)clearCategoryImageCache
{
    [[SDImageCache sd_PTcategory_imageCache] clearMemory];
    
    [[SDImageCache sd_PTcategory_imageCache] clearDisk];
}
/**
 *  删除自己扩展的存储处理过图片的磁盘缓存中所有过期的存储如果超过最大值的话还会从最旧的删除知道减半
 */
- (void)cleanCategoryDiskCache
{
    [[SDImageCache sd_PTcategory_imageCache] cleanDisk];
}

/**
 *  sd所有的缓存空间(内存和磁盘)
 *  @return ***MB
 */
- (CGFloat)cacheSize
{
    CGFloat sizeb = [[SDImageCache sharedImageCache]getSize] + [[SDImageCache sd_PTcategory_imageCache]getSize] + [[SDImageCache sharedImageCache]maxMemoryCost] + [[SDImageCache sd_PTcategory_imageCache]maxMemoryCost];
    return  sizeb / (1024 * 1024);// 1MB = 1024 *1024 b
}

/**
    重写存储方法,所有图片强制转成png,png不会失去透明度
 */
/*
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#pragma mark ImageCache

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk {
    if (!image || !key) {
        return;
    }
    [[self valueForKey:@"memCache"] setObject:image forKey:key cost:image.size.height * image.size.width * image.scale * image.scale];
    
    if (toDisk) {
        dispatch_async(dispatch_queue_create("com.hackemist.SDWebImageCache", DISPATCH_QUEUE_SERIAL), ^{
            NSData *data = imageData;
            
            if (image && (recalculate || !data)) {
#if TARGET_OS_IPHONE
                // We need to determine if the image is a PNG or a JPEG
                // PNGs are easier to detect because they have a unique signature (http://www.w3.org/TR/PNG-Structure.html)
                // The first eight bytes of a PNG file always contain the following (decimal) values:
                // 137 80 78 71 13 10 26 10
                
                // We assume the image is PNG, in case the imageData is nil (i.e. if trying to save a UIImage directly),
                // we will consider it PNG to avoid loosing the transparency
                BOOL imageIsPng = YES;
                
                // But if we have an image data, we will look at the preffix
                if (imageIsPng) {
                    data = UIImagePNGRepresentation(image);
                }
                else {
                    data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
                }
#else
                data = [NSBitmapImageRep representationOfImageRepsInArray:image.representations usingType: NSJPEGFileType properties:nil];
#endif
            }
            
            if (data) {
                if (![[self valueForKey:@"_fileManager"] fileExistsAtPath:[self valueForKey:@"diskCachePath"]]) {
                    [[self valueForKey:@"_fileManager"] createDirectoryAtPath:[self valueForKey:@"diskCachePath"] withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                
                [[self valueForKey:@"_fileManager"] createFileAtPath:[self defaultCachePathForKey:key] contents:data attributes:nil];
            }
        });
    }
}
#pragma clang diagnostic pop
*/
@end
