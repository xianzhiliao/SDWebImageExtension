//
//  UIImage+GLImageStyle.m
//  UIImage
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "UIImage+GLImageStyle.h"
#import "SDWebImageDecoder.h"
#import "SDImageCache+Category.h"

@implementation UIImage (GLImageStyle)

/* Make a GLImageStyleRoundRect */
GLImageStyleRoundRect GLImageStyleRoundRectMake(CGFloat radius)
{
    GLImageStyleRoundRect roundRect;
    roundRect.radius = radius;
    return roundRect;
}

/**
 *  将图片处理成圆角图片
 *
 *  @return 处理过后的圆角图片
 */

+ (UIImage *)GLImage:(UIImage *)image StyleRoundRect:(GLImageStyleRoundRect)glImageStyleRoundRect inImageView:(UIImageView *)imageView
{
    CGFloat imageViewWidth = imageView.frame.size.width;
    CGFloat imageViewHeight = imageView.frame.size.height;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat heightWidthPercent = imageHeight / imageWidth;
    CGFloat radius = glImageStyleRoundRect.radius;
    if (imageView.contentMode == UIViewContentModeScaleToFill) {
        CGSize canvasSize = CGSizeMake(imageViewWidth, imageViewHeight);
        CGRect drawRect = CGRectMake(0,0,imageViewWidth,imageViewHeight);
        return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
    }
    else if(imageView.contentMode == UIViewContentModeScaleAspectFit)
    {
        // 画布大小和绘制区域
        if (imageViewHeight >= imageViewWidth) {
            CGSize canvasSize = CGSizeMake(imageViewHeight / heightWidthPercent, imageViewHeight);
            CGRect drawRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
            return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        }
        else
        {
            CGSize canvasSize = CGSizeMake(imageViewWidth,imageViewWidth * heightWidthPercent);
            CGRect drawRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
            return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        }
    }
    else if(imageView.contentMode == UIViewContentModeScaleAspectFill)
    {
        //        // 画布大小和绘制区域
        //        if (imageHeight / imageWidth >= imageViewHeight / imageViewWidth) {
        //            if(imageViewWidth /imageWidth >= imageViewHeight / imageHeight)
        //            {
        //                CGSize canvasSize = CGSizeMake(imageWidth * imageHeight / imageWidth, imageViewWidth * imageHeight / imageWidth);
        //                CGRect drawRect = CGRectMake((canvasSize.width - imageWidth)/2 ,(canvasSize.height - imageHeight) / 2,imageWidth,imageHeight);
        //                return [self GLImageStyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        //            }
        //            else
        //            {
        //                CGSize canvasSize = CGSizeMake(imageViewWidth * imageHeight / imageWidth, imageViewHeight * imageHeight / imageWidth);
        //                CGRect drawRect = CGRectMake((canvasSize.width - imageViewWidth)/2,(canvasSize.height - imageViewHeight) / 2,imageViewWidth,imageViewHeight);
        //                return [self GLImageStyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        //            }
        //        }
        //        else
        //        {
        //            if(imageViewWidth >= imageWidth)
        //            {
        //                CGSize canvasSize = CGSizeMake(imageWidth * imageViewHeight / imageViewWidth, imageHeight * imageViewHeight / imageViewWidth);
        //                CGRect drawRect = CGRectMake((canvasSize.width - imageWidth)/2,(canvasSize.height - imageHeight) / 2,imageWidth,imageHeight);
        //
        //                return [self GLImageStyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        //            }
        //            else
        //            {
        //                CGSize canvasSize = CGSizeMake(imageViewWidth * imageViewHeight / imageViewWidth, imageViewHeight * imageViewHeight / imageViewWidth);
        //                CGRect drawRect = CGRectMake((canvasSize.width - imageViewWidth)/2,(canvasSize.height - imageViewHeight) / 2,imageViewWidth,imageViewHeight);
        //                return [self GLImageStyleRoundRectRadius:radius CanvasSize:canvasSize InDrawRect:drawRect];
        //            }
        //        }
        
        return nil;
    }
    else
    {
        return nil;
    }
    
}
+ (UIImage *)GLImage:(UIImage *)image StyleRoundRectRadius:(CGFloat)radius CanvasSize:(CGSize )canvasSize InDrawRect:(CGRect)drawRect
{
    // 创建上下文
    //    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    // 上面创建的图片清晰度和质量没有第下面方法好(参数意义，size指定将来创建出来的bitmap的大小,yes 表示透明，scale 0表示不缩放)
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置画笔宽
    //    CGContextSetLineWidth(context, 2);
    // 设置画笔颜色
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    // 画圆
    //    CGContextAddEllipseInRect(context, rect);
    // 画圆角矩形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, NULL, drawRect, radius,radius);
    CGContextAddPath(context, path);
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    // 裁减
    CGContextClip(context);
    [image drawInRect:drawRect];
    // 渲染
    CGContextStrokePath(context);
    // 获取处理过后的图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSLog(@"before image size is %@",NSStringFromCGSize(image.size));
    if ([SDImageCache sd_PTcategory_imageCache].shouldDecompressImages) {
        image = [UIImage decodedImageWithImage:image];
//        NSLog(@"after image size is %@",NSStringFromCGSize(image.size));
    }
    return image;
}

@end
