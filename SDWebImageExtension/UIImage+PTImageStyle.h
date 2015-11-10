//
//  UIImage+GLImageStyle.h
//  UIImage
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//
#import <UIKit/UIKit.h>

struct PTImageFormater {
    CGFloat radius; // 圆角
    CGSize size;    // 大小
    UIViewContentMode contentMode; // imageview 填充模式
};
typedef struct PTImageFormater PTImageFormater;

/* Make a PTImageFormater */
PTImageFormater PTImageFormaterMake(CGFloat radius,CGSize size,UIViewContentMode contentMode);


@interface UIImage (PTImageStyle)
/**
 *  将图片处理成样式图片
 *  @param glImageFormater 图片样式
 *  @return 处理过后的圆角图片
 */
- (UIImage *)imageWithPTImageFormater:(PTImageFormater)ptImageFormater;

@end
