//
//  JBMessageDAL.m
//  e家帮
//
//  Created by ejb on 16/3/19.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBMemoDAL.h"
#import "JBSQLiteManager.h"
#import "FMDatabase.h"
#import "JBMemo.h"

@implementation JBMemoDAL
/// 单例
+ (instancetype)sharedInstance
{
    @synchronized(self){
        return [[self alloc]init];
    }
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

 
- (NSMutableArray *)selectAllMemos
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM T_Memo"];
    NSMutableArray  *memos = [NSMutableArray array];
    
    [[JBSQLiteManager sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        // 获取数据
        while (result.next) {
            
            JBMemo *memo = [[JBMemo alloc]init];
            memo.memo_id = [result intForColumn:@"memo_id"];
            memo.memo_time = [result stringForColumn:@"memo_time"];
            memo.contents = [result stringForColumn:@"contents"];
            memo.imageNames = [result stringForColumn:@"imageNames"];
            memo.textContent = [result stringForColumn:@"textContent"];
            memo.headerIcon = @"task";
            memo.voiceNum = [result intForColumn:@"voiceNum"];
            memo.picNum = [result intForColumn:@"picNum"];
            [memos addObject:memo];
        }
    }];
    NSLog(@"获取到数据库中有%lu条数据",memos.count);
    return [memos copy];
}
- (BOOL)insertOneMemoWithMemo:(JBMemo *)memo
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Memo (memo_time, contents ,imageNames,textContent,voiceNum,picNum) VALUES ( \"%@\", \"%@\",\"%@\", \"%@\",%d,%d)",memo.memo_time,memo.contents,memo.imageNames,memo.textContent,memo.voiceNum,memo.picNum];

    __block BOOL isSuccessed = NO;
    [[JBSQLiteManager sharedInstance].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 添加Message数据到数据库
        if ([db executeUpdate:sql]) {
            isSuccessed = YES;
            JBLog(@"添加Message数据到数据库成功!");
        }else{
            rollback = (BOOL *)YES;
            JBLog(@"添加Message数据到数据库失败!");
        }
    }];
    
    return isSuccessed;
}

- (BOOL)deleteMemoWithMemo_id:(int)memo_id
{
    // 生成sql语句
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Memo WHERE memo_id = %d",memo_id];
    __block BOOL isSuccessed = NO;
    [[JBSQLiteManager sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql]) {
            isSuccessed = YES;
            JBLog(@"删除一条备忘录成功!");
        }
    }];
    return isSuccessed;
}

- (BOOL)updateOneMemoWithMemo:(JBMemo *)memo {
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE T_Memo SET memo_time = '%@', contents = '%@',imageNames = '%@', textContent = '%@', voiceNum = %d, picNum = %d WHERE memo_id = %d",memo.memo_time,memo.contents,memo.imageNames,memo.textContent,memo.voiceNum,memo.picNum, memo.memo_id];
    NSLog(@"%@",sql);
    __block BOOL isSuccessed = NO;
    [[JBSQLiteManager sharedInstance].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 添加Message数据到数据库
        if ([db executeUpdate:sql]) {
            isSuccessed = YES;
            JBLog(@"修改一条备忘录成功!");
        }else{
            rollback = (BOOL *)YES;
            JBLog(@"修改一条备忘录失败!");
        }
    }];
    return isSuccessed;
}

@end

