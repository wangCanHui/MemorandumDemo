//
//  NSString+Extension.h
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/31.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)
/// 根据文字大小和宽度计算出文本的高度
- (CGFloat)heightWithFontSize:(CGFloat)fontSize Width:(CGFloat)width;
@end
