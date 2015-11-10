//
//  MyTableViewCell.h
//  ImgeCache
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MyTableViewCellHeight  88.0f
#import "UIImage+PTImageStyle.h"

@interface MyTableViewCell : UITableViewCell

@property (nonatomic ,strong)UIImageView *myImageView;
+ (PTImageFormater)getImageFormater;
@end
