//
//  LJOrmDBTable.m
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

#import "LJOrmDBTable.h"

@implementation LJOrmDBTable

-(NSString *)description{
    return [NSString stringWithFormat:@"table：%@", self.name];
}

#pragma mark - Getter && Setter

@end

@implementation LJOrmDBColumn

-(instancetype) init:(NSString *)name type:(NSString *)type isPK:(BOOL)isPK{
    
    if (self = [self init]) {
        _name = name;
        _type = type;
        _isPK = isPK;
    }
    return self;
}

@end
