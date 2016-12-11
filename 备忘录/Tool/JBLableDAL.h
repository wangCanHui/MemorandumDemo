//
//  JBLableDAL.h
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/31.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBLabel;
@interface JBLableDAL : NSObject
/// 推送消息数据库管理类
/// 单例
+ (instancetype)sharedInstance;
// 查询某一张图片的所有标签
- (JBLabel *)selectWithImageName:(NSString *)imageName;
/**
 *  删除某一张图片的所有标签
 */
- (BOOL)deleteWithImageName:(NSString *)imageName;
/**
 *  插入一张图片的所有标签
 */
- (BOOL)insertWithLabel:(JBLabel *)label;

/**
 *  修改一张图片的所有标签
 */
- (BOOL)updateWithLabel:(JBLabel *)label;
@end
