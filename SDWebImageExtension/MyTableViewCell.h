//
//  MyTableViewCell.h
//  ImgeCache
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#define MyTableViewCellHeight  88.0f
@interface MyTableViewCell : UITableViewCell<SDWebImageManagerDelegate>

@property (nonatomic ,strong)UIImageView *myImageView;
@end
