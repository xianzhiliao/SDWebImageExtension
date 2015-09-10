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
#import "UIImage+GLImageStyle.h"
#import "SDWebImageDecoder.h"
#import "UIImageView+SizeFit.h"

#define MarginLeftAndRight 15
#define MarginTopAndBottom 15

@interface MyTableViewCell()



@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubView];
    }
    return self;
}

- (void)createSubView
{
    _myImageView = [UIImageView new];
    _myImageView.backgroundColor = [UIColor clearColor];
    _myImageView.contentMode = UIViewContentModeScaleToFill;
    CGFloat imageWidth = (MyTableViewCellHeight - 2 * MarginTopAndBottom);
//     先设置宽高,否则有时会获取不到(因为还没调用layoutSubviews)
    _myImageView.frame = CGRectMake(0, 0, imageWidth, imageWidth);
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_myImageView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak __typeof(&*self)weakSelf = self;
    CGFloat imageWidth = (MyTableViewCellHeight - 2 * MarginTopAndBottom);
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(MarginLeftAndRight);
        make.top.equalTo(weakSelf.contentView).offset(MarginTopAndBottom);
        make.width.mas_equalTo(imageWidth);
        make.height.mas_equalTo(imageWidth);
    }];
}


#pragma mark - SDWebImageManagerDelegate

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    // 处理图片,返回处理过的图片会自动保存到sd_category_imageCache存储路径,如果需要原图保存到sharedImageCache,如果不需要保存原图，不保存
    UIImage *formaterImage = [UIImage GLImage:image StyleRoundRect:GLImageStyleRoundRectMake(_myImageView.frame.size.height / 4)inImageView:_myImageView];
//    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:imageURL];
    // 需要的话将原图片保存
//    [[SDWebImageManager sharedManager].imageCache storeImage:image forKey:key];
    // 返回处理过的图片
//    _myImageView.image = formaterImage;
    return formaterImage;
}

#pragma mark end

@end
