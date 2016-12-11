//
//  NSUserDefaults+Extension.m
//  e家帮
//
//  Created by GMobile No.2 on 16/3/11.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)

+ (void)saveCookieWithCookie:(NSHTTPCookie *)cookie
{
    if ([cookie.name isEqualToString:@"JSESSIONID"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogined"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.name forKey:@"cookieName"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.value forKey:@"cookieValue"];
        NSNumber *version = [NSNumber numberWithInteger:cookie.version];
        [[NSUserDefaults standardUserDefaults]setObject:version forKey:@"cookieVersion"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.domain forKey:@"cookieDomain"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.path forKey:@"cookiePath"];
        [[NSUserDefaults standardUserDefaults] setObject:cookie.expiresDate forKey:@"cookieExpiresDate"];
    }else if ([cookie.name isEqualToString:@"ejbusertoken"]){
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogined"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.name forKey:@"cookieName1"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.value forKey:@"cookieValue1"];
        NSNumber *version = [NSNumber numberWithInteger:cookie.version];
        [[NSUserDefaults standardUserDefaults]setObject:version forKey:@"cookieVersion1"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.domain forKey:@"cookieDomain1"];
        [[NSUserDefaults standardUserDefaults]setObject:cookie.path forKey:@"cookiePath1"];
        [[NSUserDefaults standardUserDefaults] setObject:cookie.expiresDate forKey:@"cookieExpiresDate"];
    }
}


+ (NSArray *)getCookies
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSHTTPCookie *cookie = nil;
    NSMutableArray *cookies = [NSMutableArray array];
    if ([[defaults objectForKey:@"cookieName"] isEqualToString:@"JSESSIONID"]) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[defaults objectForKey:@"cookieName"] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[defaults objectForKey:@"cookieValue"] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[defaults objectForKey:@"cookieDomain"] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[defaults objectForKey:@"cookiePath"] forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[defaults objectForKey:@"cookieVersion"] forKey:NSHTTPCookieVersion];
        cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [cookies addObject:cookie];
    }
    if ([[defaults objectForKey:@"cookieName1"] isEqualToString:@"ejbusertoken"]){
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[defaults objectForKey:@"cookieName1"] forKey:NSHTTPCookieName];
        [cookieProperties setObject:[defaults objectForKey:@"cookieValue1"] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:[defaults objectForKey:@"cookieDomain1"] forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:[defaults objectForKey:@"cookiePath1"] forKey:NSHTTPCookiePath];
        [cookieProperties setObject:[defaults objectForKey:@"cookieVersion1"] forKey:NSHTTPCookieVersion];
        cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [cookies addObject:cookie];
    }
    return cookies;
}

+ (NSString *)getAccount
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"account"];
}

+ (NSString *)getDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
