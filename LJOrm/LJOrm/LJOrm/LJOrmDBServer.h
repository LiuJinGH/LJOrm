//
//  LJOrmDBServer.h
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

/**
 ORM 数据库服务器
 
 1. 通过FMDB创建ORM数据库，并建议连接。
 2. 根据ORM Model 创建或删除数据库表。
 3. 执行相关SQL语句。
 
 */

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "LJOrmConfiguration.h"

@interface LJOrmDBServer : NSObject

+(instancetype) sharedInstance;

/**
 ORM数据库表
 */
@property (nonatomic, strong) NSArray<LJOrmDBTable *> *tables;


/**
 创建数据库表

 @param table 数据库表信息
 @return 是否创建成功
 */
-(BOOL) creataTable:(LJOrmDBTable *)table;

/**
 对某个ORM数据库表进行清空操作

 @param tableName 数据库表名
 */
-(void)clearAllWithTable:(NSString *)tableName;

/**
 对所有ORM数据库表进行清空操作
 */
-(void)clearAllWithAllTables;

@end


