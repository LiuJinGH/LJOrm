
//
//  LJOrmDBServer.m
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

#import "LJOrmDBServer.h"

@interface LJOrmDBServer(){
    NSMutableArray<LJOrmDBTable *> *_tables;
}

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation LJOrmDBServer

+(instancetype) sharedInstance
{
    static LJOrmDBServer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Method

// 查询
-(NSMutableArray *) queryBySQL:(NSString*)sql
{
    //__block NSString *queryContent;
    __block NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            //queryContent = [rs stringForColumn:@"content"];
            //break;
            // 将每一条记录转化为 字典类型
            NSDictionary *dic = [rs resultDictionary];
            [resultArray addObject:dic];
        }
        [rs close];
    }];
    
    return resultArray;
}

-(BOOL) isExistTable:(NSString *)tableName;{
    
    __block BOOL isExistTable = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString * sql = [[NSString alloc] initWithFormat:@"select name from sqlite_master where type = 'table' and name = '%@'",tableName];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            NSString *name = [rs stringForColumn:@"name"];
            
            if ([name isEqualToString:tableName]){
                
                isExistTable =YES;
                
            }
            
        }
        
    }];
    
    return isExistTable;
}

-(NSArray<LJOrmDBColumn *> *) columnsWithTable:(NSString *)tableName{
    __block NSMutableArray<LJOrmDBColumn *> *columns = [NSMutableArray new];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        // 表中已经存在的列
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            
            NSString *name = [resultSet stringForColumn:@"name"];
            NSString *type = [resultSet stringForColumn:@"type"];
            BOOL isPK = [resultSet intForColumn:@"PK"];
            LJOrmDBColumn *column = [[LJOrmDBColumn alloc] init:name type:type isPK:isPK];
            [columns addObject:column];
            
        }
        
    }];
    
    return columns;
}

// 建表
-(BOOL) creataTable:(LJOrmDBTable *)table{
    __block BOOL dbSuccess = NO;
//    __block NSArray *tempName = [dict objectForKey:@"name"];
    __block BOOL isNeedUpdate = NO;
    
    if ([self isExistTable:table.name]) {
        
        
        
        if (isNeedUpdate) {
            
        }
        
    }else{
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",table.name,table.columeAndType];
            
            dbSuccess = [db executeUpdate:sql];
            
            if(dbSuccess)
            {
                return;
            }
        }];
    }
    
    return dbSuccess;
}

-(void)clearAllWithTable:(NSString *)tableName{
    [self.dbQueue inDatabase:^(FMDatabase *db) {

        BOOL dbSuccess = [db executeUpdate:@"DELETE FROM ?",tableName];
        if (dbSuccess) {
            ORM_LOG(@"LJORM: Table: %@已清空", tableName);
        }else {
            ORM_LOG(@"LJORM: Table: %@清空失败", tableName);
        }
        
    }];
}

-(void)clearAllWithAllTables{

    ORM_LOG(@"LJORM: 即将对所有ORM数据库表进行清空操作");
    
    for (LJOrmDBTable *dbTable in self.tables){
        [self clearAllWithTable:dbTable.name];
    }

}

-(BOOL) deleteTable:(NSString *)table{
    __block BOOL res = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", table];
        
        res = [db executeUpdate:sql];
        
    }];
    
    return res;
}

#pragma mark - Getter && Setter

-(FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        ORM_LOG(@"LJORM: 启动ORM数据库服务器");
        NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:ORM_DATA_NAME];
        ORM_LOG(@"LJORM: 数据库路径为：%@", dbPath);
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return _dbQueue;
}

-(NSArray<LJOrmDBTable *> *)tables{
    if (!_tables) {
        _tables = [NSMutableArray new];
    }
    return _tables;
}

@end
