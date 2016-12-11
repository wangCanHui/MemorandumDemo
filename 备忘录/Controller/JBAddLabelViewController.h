//
//  JBAddLabelViewController.h
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/25.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBLabel;
@interface JBAddLabelViewController : BaseViewController<UIViewControllerTransitioningDelegate>
// 原图
//@property (nonatomic,strong) UIImage *image;
@property (nonatomic,copy) NSString *imageName;
// 过渡图片
@property (nonatomic,strong) UIImageView *tempImageView;
// 目标图片
@property (nonatomic,strong) UIImageView *targetImageView;
@property (nonatomic,copy) void(^saveBlock)(UIImage *image,NSArray *tempPoints,NSArray *tempTexts);
@property (nonatomic,strong) JBLabel *label;
@property (nonatomic,copy) void(^backBlock)();
@end
