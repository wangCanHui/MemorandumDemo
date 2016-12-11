//
//  JBSQLiteManager.m
//  e家帮
//
//  Created by ejb on 16/3/18.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBSQLiteManager.h"
#import "FMDatabase.h"

@implementation JBSQLiteManager
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
        // 创建数据库表
        [instance createTables];
    });
    return instance;
}

- (void)createTables
{
    // 从文件加载sql
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tables" ofType:@"sql"];
    NSString *sqls = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 执行sql
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeStatements:sqls]) {
            NSLog(@"创建数据表成功");
        }else{
            NSLog(@"创建数据表失败");
        }
    }];
}

#pragma mark - 懒加载
- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        // 数据库的完整路径
        NSString *dbPath = [documentPath stringByAppendingPathComponent:@"message.db"];
         // 创建 FMDatabaseQueue 对象, 如果数据库不存在就会创建数据库,自动打开数据库,并创建一个串行队列,后续操作数据库都使用这个对象
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return _dbQueue;
}
@end
