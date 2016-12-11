//
//  NSString+Extension.m
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/31.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGFloat)heightWithFontSize:(CGFloat)fontSize Width:(CGFloat)width
{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}


@end
