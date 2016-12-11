//
//  NSDate+Extension.m
//  wch
//
//  Created by 李海生 on 15/9/10.
//  Copyright (c) 2015年 李海生. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=format;
    return [formatter stringFromDate:date];
}
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)format
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=format;
    return [formatter dateFromString:string];
}
/// 获取时间戳
+ (NSString *)getTimeStamp
{
    // 根据当前时间来生成文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStamp = [formatter stringFromDate:[NSDate date]];
    return timeStamp;
}


@end
