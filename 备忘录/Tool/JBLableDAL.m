//
//  JBLableDAL.m
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/31.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBLableDAL.h"
#import "JBLabel.h"
#import "FMDatabase.h"
#import "JBSQLiteManager.h"

@implementation JBLableDAL
/// 单例
+ (instancetype)sharedInstance
{
    @synchronized(self) {
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

- (JBLabel *)selectWithImageName:(NSString *)imageName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM T_Label WHERE imageName = '%@'",imageName];
    JBLabel *label = [[JBLabel alloc]init];
    [[JBSQLiteManager sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:sql];
        // 获取数据
        while (result.next) {
            label.imageName = [result stringForColumn:@"imageName"];
            label.points = [result stringForColumn:@"points"];
            label.texts = [result stringForColumn:@"texts"];
            JBLog(@"成功查询到一条数据");
        }
    }];
    return label;
}

- (BOOL)insertWithLabel:(JBLabel *)label
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO T_Label (imageName, points, texts ) VALUES ( \"%@\", \"%@\", \"%@\")",label.imageName,label.points,label.texts];
    JBLog(@"%@",sql);
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

- (BOOL)updateWithLabel:(JBLabel *)label
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE T_Label SET points = '%@', texts = '%@' WHERE imageName = '%@'",label.points,label.texts,label.imageName];
    JBLog(@"%@",sql);
    __block BOOL isSuccessed = NO;
    [[JBSQLiteManager sharedInstance].dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 添加Message数据到数据库
        if ([db executeUpdate:sql]) {
            isSuccessed = YES;
            JBLog(@"修改一条备忘录成功!");
        }else{
            rollback = (BOOL *)YES;
            JBLog(@"修改一条备忘录失败！");
        }
    }];
    return isSuccessed;
}

- (BOOL)deleteWithImageName:(NSString *)imageName
{
    // 生成sql语句
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM T_Label WHERE imageName = '%@'",imageName];
    __block BOOL isSuccessed = NO;
    [[JBSQLiteManager sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:sql]) {
            isSuccessed = YES;
            JBLog(@"删除一条备忘录成功!");
        }
    }];
    return isSuccessed;
}


@end
