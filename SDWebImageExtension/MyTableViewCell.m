//
//  MyTableViewCell.m
//  ImgeCache
//
//  Created by xianzhiliao on 15/8/24.
//  Copyright (c) 2015年 xianzhiliao. All rights reserved.
//

#import "MyTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+PTImageStyle.h"
#import "SDWebImageDecoder.h"
#import "UIImageView+SizeFit.h"

#define MarginLeftAndRight 15
#define MarginTopAndBottom 15

@interface MyTableViewCell()

@property (nonatomic, strong)UIView *bottomLine;

@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _myImageView = [UIImageView new];
    _myImageView.backgroundColor = [UIColor clearColor];
    _myImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_myImageView];
    
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0];
    [self.contentView addSubview:_bottomLine];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak __typeof(&*self)weakSelf = self;
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(MarginLeftAndRight);
        make.top.equalTo(weakSelf.contentView).offset(MarginTopAndBottom);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1.0f);
        make.left.right.equalTo(weakSelf.contentView);
    }];
}

+ (PTImageFormater)getImageFormater
{
    return PTImageFormaterMake(30, CGSizeMake(60, 60), UIViewContentModeScaleToFill);
}
@end
