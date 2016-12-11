//
//  NSDate+Extension.h
//  wch
//
//  Created by 李海生 on 15/9/10.
//  Copyright (c) 2015年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format;
/// 获取时间戳
+ (NSString *)getTimeStamp;
@end
