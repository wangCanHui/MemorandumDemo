//
//  UILabel+CHExtension.m
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "UILabel+CHExtension.h"

@implementation UILabel (CHExtension)

+ (instancetype)labelWithText:(NSString *)text TextColor:(UIColor *)textColor backgroundColor:(UIColor *)bkgColor fontSize:(CGFloat)size;
{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = textColor;
    if (bkgColor!=nil) {
        label.backgroundColor = bkgColor;
    }
    [label sizeToFit];
    return label;
}

@end
