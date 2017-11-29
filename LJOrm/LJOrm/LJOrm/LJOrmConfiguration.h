//
//  LJOrmConfiguration.h
//  LJOrm
//
//  Created by 刘瑾 on 2017/11/29.
//  Copyright © 2017年 刘瑾. All rights reserved.
//

/**
 初始配置文件
 */

#ifndef LJOrmConfiguration_h
#define LJOrmConfiguration_h

#define ORM_DATA_NAME @"ORM.sqlite"

#define ORM_LOG_ENABLE YES

#if ORM_LOG_ENABLE == YES
#define ORM_LOG(...) NSLog(__VA_ARGS__)
#else
#define ORM_LOG(...) {}
#endif

#import "LJOrmDBTable.h"

#import "LJOrmDBServer.h"
#define ORM_SERVER_INSTANCE [LJOrmDBServer sharedInstance]

#endif /* LJOrmConfiguration_h */
