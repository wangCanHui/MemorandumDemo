//
//  JBMemoDAL.h
//  e家帮
//
//  Created by ejb on 16/3/19.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 推送消息数据库管理类
@class JBMemo;
@interface JBMemoDAL : NSObject
/// 单例
+ (instancetype)sharedInstance;
// 查询出所有的备忘录
- (NSMutableArray *)selectAllMemos;
/**
 *  删除某条备忘录
 */
- (BOOL)deleteMemoWithMemo_id:(int)memo_id;
/**
 *  插入一条备忘录
 */
- (BOOL)insertOneMemoWithMemo:(JBMemo *)memo;
// 修改一条备忘录
- (BOOL)updateOneMemoWithMemo:(JBMemo *)memo;
@end
