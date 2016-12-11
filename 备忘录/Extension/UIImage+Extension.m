//
//  UIImage+Extension.m
//
//  Created by 李海生 on 15/9/10.
//  Copyright (c) 2015年 李海生. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (instancetype)resizeImageWithName:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:imageName];
    CGFloat top=image.size.height*0.5;
    CGFloat left=image.size.width*0.5;
    return  [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left) resizingMode:UIImageResizingModeStretch];
}

- (instancetype)scaleImage
{
    // 缩小后图片的宽度
    CGFloat newWidth = JBScreenWidth*0.5;
    
    CGSize size = self.size;
    // 图片宽度本来就小于300
    if (size.width < newWidth) {
        return self;
    }
    CGFloat newHeight = size.height * newWidth / size.width;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    // 准备图片的上下文
    UIGraphicsBeginImageContext(newSize);
    // 将当前图片绘制到rect上面
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    // 从上下文获取绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (instancetype)scaleImageForMemoImage
{
    // 缩小后图片的宽度
    CGFloat newWidth = JBScreenWidth-20;
    
    CGSize size = self.size;
    // 图片宽度本来就小于300
    if (size.width < newWidth) {
        return self;
    }
    CGFloat newHeight = size.height * newWidth / size.width;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    // 准备图片的上下文
    UIGraphicsBeginImageContext(newSize);
    // 将当前图片绘制到rect上面
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    // 从上下文获取绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (instancetype)scaleImageWithScreenScale:(CGFloat)scale
{
    // 缩小后图片的宽度
    CGFloat newWidth = JBScreenWidth*scale;
    
    CGSize size = self.size;
    // 图片宽度本来就小于newWidth
    if (size.width < newWidth) {
        return self;
    }
    CGFloat newHeight = size.height * newWidth / size.width;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    // 准备图片的上下文
    UIGraphicsBeginImageContext(newSize);
    // 将当前图片绘制到rect上面
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    // 从上下文获取绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (CGSize)displaySize
{
    // 新的高度 / 新的宽度 = 原来的高度 / 原来的宽度
    // 新的宽度
    CGFloat newWidth = JBScreenWidth;
    CGFloat newHeight = self.size.height * newWidth / self.size.width;
    
    return CGSizeMake(newWidth, newHeight);
}

@end
