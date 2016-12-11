//
//  NSUserDefaults+Extension.h
//  e家帮
//
//  Created by GMobile No.2 on 16/3/11.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extension)
/**
 *  保存Cookie信息
 */
+ (void)saveCookieWithCookie:(NSHTTPCookie *)cookie;

/**
 *  获取Cookies信息
 */
+ (NSArray *)getCookies;
/**
 *  获取小米登陆账号
 *
 *  @return 小米登陆账号
 */
+ (NSString *)getAccount;


/**
 *  获取沙河document文件夹路径
 */
+ (NSString *)getDocumentPath;
@end
