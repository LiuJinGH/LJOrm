//
//  LJOrmModel.m
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

#import "LJOrmModel.h"

@implementation LJOrmModel

// 初始化时创建表
+ (void)initialize
{
    if (self != [LJOrmModel self]) {
        
    }
}

// 获取该类的所有属性
+ (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    NSMutableArray *proClass = [NSMutableArray array];
    
//    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        if ([theTransients containsObject:propertyName]) {
//            continue;
//        }
        if ([[[self class] getPrimaryKey] isEqualToString:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数 - 根据参数类型选择数据库字段类型
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         */
        if ([propertyType hasPrefix:@"T@"]) {
            NSArray *temp = [propertyType componentsSeparatedByString:@"\""];
            [proClass addObject:temp[1]];
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]) {
            [proTypes addObject:SQLINTEGER];
            [proClass addObject:@"int"];
        } else {
            [proTypes addObject:SQLREAL];
            [proClass addObject:@"NSString"];
        }
        
    }
    free(properties);
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",proClass,@"class", nil];
}

@end
