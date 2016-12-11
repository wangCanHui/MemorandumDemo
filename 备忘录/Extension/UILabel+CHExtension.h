//
//  UILabel+CHExtension.h
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CHExtension)

/// 快速创建label
+ (instancetype)labelWithText:(NSString *)text TextColor:(UIColor *)textColor backgroundColor:(UIColor *)bkgColor fontSize:(CGFloat)size;

@end
