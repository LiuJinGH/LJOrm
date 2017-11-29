//
//  LJOrmDBTable.h
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJOrmDBColumn;

@interface LJOrmDBTable : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) float size;
@property (nonatomic, strong) NSString *columeAndType;
// 获取数据库中表的列名
@property (nonatomic, strong, readonly) NSArray<LJOrmDBColumn *> *DBcolumns;
@property (nonatomic, strong, readonly) NSArray<LJOrmDBColumn *> *Modelcolumns;

@end

@interface LJOrmDBColumn : NSObject

-(instancetype) init:(NSString *)name
                type:(NSString *)type
                isPK:(BOOL)isPK;

@property (nonatomic, assign, readonly) BOOL isPK;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *type;

@end
