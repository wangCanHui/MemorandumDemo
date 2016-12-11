//
//  UIImage+Extension.h
//
//  Created by 李海生 on 15/9/10.
//  Copyright (c) 2015年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (instancetype)resizeImageWithName:(NSString *)imageName;
/**
 *  等比例缩小, 缩小到宽度等于300
 *
 *  @return 缩小后的图片
 */
- (instancetype)scaleImage;

- (instancetype)scaleImageForMemoImage;
/**
 *  等比例缩放, 缩放到屏幕宽度等于scale的比例
 *
 *  @param scale 相对于屏幕比例
 *
 *  @return 缩放后的图片
 */
- (instancetype)scaleImageWithScreenScale:(CGFloat)scale;

/**
 *  将图片等比例缩放, 缩放到图片的宽度等屏幕的宽度
 *
 *  @return 缩放后的大小
 */
- (CGSize)displaySize;
@end
