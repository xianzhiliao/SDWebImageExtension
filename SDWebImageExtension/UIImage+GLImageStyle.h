//
//  UIImage+GLImageStyle.h
//  UIImage
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//
#import <UIKit/UIKit.h>

/* GLImageStyleRoundRect */
struct GLImageStyleRoundRect {
    CGFloat radius;
};
typedef struct GLImageStyleRoundRect GLImageStyleRoundRect;

/* Make a GLImageStyleRoundRect */
GLImageStyleRoundRect GLImageStyleRoundRectMake(CGFloat radius);




@interface UIImage (GLImageStyle)

/**
 *  将图片处理成圆角图片
 *
 *  @return 处理过后的圆角图片
 */
+ (UIImage *)GLImage:(UIImage*)image StyleRoundRect:(GLImageStyleRoundRect)glImageStyleRoundRect inImageView:(UIImageView *)imageView;

@end
