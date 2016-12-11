//
//  UIButton+CHExtension.h
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CHExtension)

/// 快速创建button
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)size imageName:(NSString *)imageName bkgimageName:(NSString *)bkgimageName target:(id)target action:(SEL)action;

@end
