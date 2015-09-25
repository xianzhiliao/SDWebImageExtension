//
//  UIImage+GLImageStyle.m
//  UIImage
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "UIImage+GLImageStyle.h"
#import "SDWebImageDecoder.h"
#import "SDImageCache+PTCache.h"

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
        return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize imageViewBackgroundColor:imageView.backgroundColor InDrawRect:drawRect];
    } // 后面两种格式在不透明的情况下都有问题
    else if(imageView.contentMode == UIViewContentModeScaleAspectFit)
    {
        // 画布大小和绘制区域
        if (imageViewHeight >= imageViewWidth) {
            CGSize canvasSize = CGSizeMake(imageViewHeight / heightWidthPercent, imageViewHeight);
            CGRect drawRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
            return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize imageViewBackgroundColor:imageView.backgroundColor InDrawRect:drawRect];
        }
        else
        {
            CGSize canvasSize = CGSizeMake(imageViewWidth,imageViewWidth * heightWidthPercent);
            CGRect drawRect = CGRectMake(0, 0, canvasSize.width, canvasSize.height);
            return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize imageViewBackgroundColor:imageView.backgroundColor InDrawRect:drawRect];
        }
    }
    else if(imageView.contentMode == UIViewContentModeScaleAspectFill)
    {
        // 画布大小为图片放缩后的大小,drawRect是imageView的大小
        
        CGSize canvasSize;
        CGRect drawRect;
        CGFloat widthPercent = imageWidth / imageViewWidth;
        CGFloat heightPercent = imageHeight / imageViewHeight;
        CGFloat min = MIN(widthPercent, heightPercent);
        canvasSize = CGSizeMake(imageWidth / min, imageHeight / min);
        if (min == heightPercent) {
            CGFloat x = (canvasSize.width - imageViewWidth) / 2;
            drawRect = CGRectMake(x, 0, imageViewWidth, imageViewHeight);
        }
        else
        {
            CGFloat y = (canvasSize.height - imageViewHeight) / 2;
            drawRect = CGRectMake(0, y, imageViewWidth, imageViewHeight);
        }
        
        return [self GLImage:image StyleRoundRectRadius:radius CanvasSize:canvasSize imageViewBackgroundColor:imageView.backgroundColor InDrawRect:drawRect];
    }
    else
    {
        return nil;
    }
    
}
+ (UIImage *)GLImage:(UIImage *)image StyleRoundRectRadius:(CGFloat)radius CanvasSize:(CGSize )canvasSize imageViewBackgroundColor:(UIColor *)bgcolor InDrawRect:(CGRect)drawRect
{
    // 创建上下文
    //    UIGraphicsBeginImageContext(CGSizeMake(imageWidth, imageHeight));
    // 上面创建的图片清晰度和质量没有第下面方法好(参数意义，size指定将来创建出来的bitmap的大小,yes表示不透明，scale 表示缩放，0由系统计算)
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);

    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置背景色
    [bgcolor setFill];
    // 填充背景
//    UIRectFill(CGRectMake(0,0,canvasSize.width,canvasSize.height));
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

//    if ([SDImageCache sd_PTcategory_imageCache].shouldDecompressImages) {
//        image = [UIImage decodedImageWithImage:image];
//    }
    return image;
}

@end
