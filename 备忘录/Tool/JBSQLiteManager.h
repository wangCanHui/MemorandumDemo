//
//  JBSQLiteManager.h
//  e家帮
//
//  Created by ejb on 16/3/18.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"

@interface JBSQLiteManager : NSObject
/// 单例
+ (instancetype)sharedInstance;
/**
 *  操作数据库的队列
 */
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@end
