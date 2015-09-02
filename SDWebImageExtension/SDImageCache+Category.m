//
//  UIImageView+Category.m
//  UIImageView
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "objc/runtime.h"
#import "SDImageCache+Category.h"
#import "SDImageCache.h"


@implementation SDImageCache(Category)

+ (SDImageCache *)sd_category_imageCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[SDImageCache alloc]initWithNamespace:@"formater"];
    });
    return instance;
}
+ (SDImageCache *)sd_category_localImageCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[SDImageCache alloc]initWithNamespace:@"localImage"];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSMutableString *path = [NSMutableString stringWithString:[[NSBundle mainBundle]bundlePath]];
        [path appendString:@"/"];
        [instance setValue:path forKey:@"diskCachePath"];

    });
    return instance;
}
/**
    重写此方法,所有图片转成png,否则png会失去透明度
 */
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

//- (NSURL *)sd_category_imageURL {
//    return objc_getAssociatedObject(self, &imageURLKey);
//}


@end
