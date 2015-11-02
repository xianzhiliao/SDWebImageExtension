//
//  UIImage+GLImageStyle.h
//  UIImage
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//
#import <UIKit/UIKit.h>

//-----------------------------
/* GLImageFormater */
struct GLImageFormater {
    CGFloat radius;
    CGSize size;
    UIViewContentMode contentMode;
};
typedef struct GLImageFormater GLImageFormater;

/* Make a GLImageFormater */
GLImageFormater GLImageFormaterMake(CGFloat radius,CGSize size,UIViewContentMode contentMode);




@interface UIImage (GLImageStyle)

/**
 *  将图片处理成圆角图片
 *
 *  @return 处理过后的圆角图片
 */
+ (UIImage *)GLImage:(UIImage *)image imageFormater:(GLImageFormater)glImageFormater backGroundColor:(UIColor *)bgcolor;

@end
