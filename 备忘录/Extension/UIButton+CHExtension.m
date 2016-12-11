//
//  UIButton+CHExtension.m
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "UIButton+CHExtension.h"

@implementation UIButton (CHExtension)
/// 快速创建button
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)size imageName:(NSString *)imageName bkgimageName:(NSString *)bkgimageName target:(id)target action:(SEL)action;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置文本
    if (title!=nil) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    // 设置文字颜色
    if (color!=nil) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    // 设置字体大小
    if (size!=0) {
        button.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    // 设置图片
    if (imageName!=nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    // 设置背景图片
    if (bkgimageName!=nil) {
        [button setBackgroundImage:[UIImage imageNamed:bkgimageName] forState:UIControlStateNormal];
    }
    // 添加监听事件
    if (action!=nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    [button sizeToFit];
    
    return button;
}
@end
