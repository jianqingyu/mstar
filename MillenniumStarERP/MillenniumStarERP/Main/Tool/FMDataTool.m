//
//  FMDataTool.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/3.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "FMDataTool.h"
#import <FMDB.h>
static FMDataTool *_DBCtl = nil;
@interface FMDataTool()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}
@end
@implementation FMDataTool
+ (instancetype)sharedDataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[FMDataTool alloc] init];
        [_DBCtl initDataBase];
    }
    return _DBCtl;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    return _DBCtl;
}

- (id)copy{
    return self;
}

- (id)mutableCopy{
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

- (void)initDataBase{
    NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", @"driInfo" ];

    // 获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString *userSql = @"CREATE TABLE 'driInfo' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'dri_id' VARCHAR(255),'scope' VARCHAR(255),'number' VARCHAR(255),'isSel' VARCHAR(255)) ";
    
    FMResultSet *rs = [_db executeQuery:existsSql];
    if ([rs next]) {
        NSInteger count = [rs intForColumn:@"countNum"];
        if (count == 0) {
            [_db executeUpdate:userSql];
        }
    }
    
    [_db close];
}
#pragma mark - driInfo
- (void)addDriInfo:(SetDriInfo *)dri{
    [_db open];
    
    NSNumber *maxId = @(0);
    FMResultSet *res = [_db executeQuery:@"select * from driInfo"];
    //获取数据库中最大的id
    while ([res next]) {
        if ([maxId integerValue]<[[res stringForColumn:@"dri_id"]integerValue]) {
            maxId = @([[res stringForColumn:@"dri_id"]integerValue]);
        }
    }
    maxId = @([maxId integerValue]+1);
    [_db executeUpdate:@"INSERT INTO driInfo(dri_id,scope,number,isSel)VALUES(?,?,?,?)",maxId,dri.scope,dri.number,dri.isSel];
    
    [_db close];
}

- (void)deleteDriInfo:(SetDriInfo *)dri{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM driInfo WHERE dri_id = ?",dri.ID];
    
    [_db close];
}

- (NSMutableArray *)getInfoArrFromSql:(NSString *)sql{
    [_db open];
    NSString *str = [NSString stringWithFormat:@"select * from driInfo where scope = '%@'",sql];
    FMResultSet *rs = [_db executeQuery:str];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while ([rs next]) {
        SetDriInfo *model = [SetDriInfo new];
        model.ID = @([[rs stringForColumn:@"dri_id"]intValue]);
        model.scope = [rs stringForColumn:@"scope"];
        model.number = [rs stringForColumn:@"number"];
        model.isSel = @([[rs stringForColumn:@"isSel"]boolValue]);
        [arr addObject:model];
    }
    [_db close];
    return arr;
}

- (void)updateDriInfo:(SetDriInfo *)dri{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'driInfo' SET scope = ?  WHERE dri_id = ? ",dri.scope,dri.ID];
    [_db executeUpdate:@"UPDATE 'driInfo' SET number = ?  WHERE dri_id = ? ",dri.number,dri.ID];
    [_db executeUpdate:@"UPDATE 'driInfo' SET isSel = ?  WHERE dri_id = ? ",dri.isSel,dri.ID];
    [_db close];
}

- (NSMutableArray *)getAllDriInfo{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM driInfo"];
    while ([res next]) {
        SetDriInfo *dri = [SetDriInfo new];
        dri.ID = @([[res stringForColumn:@"dri_id"] integerValue]);
        dri.scope = [res stringForColumn:@"scope"];
        dri.number = [res stringForColumn:@"number"];
        dri.isSel = @([[res stringForColumn:@"isSel"]boolValue]);
        [dataArray addObject:dri];
    }
    
    [_db close];
    return dataArray;
}

- (NSMutableArray *)getAllSelDriInfo{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM driInfo"];
    while ([res next]) {
        SetDriInfo *dri = [SetDriInfo new];
        dri.ID = @([[res stringForColumn:@"dri_id"] integerValue]);
        dri.scope = [res stringForColumn:@"scope"];
        dri.number = [res stringForColumn:@"number"];
        dri.isSel = @([[res stringForColumn:@"isSel"]boolValue]);
        if ([dri.isSel boolValue]) {
            [dataArray addObject:dri];
        }
    }
    
    [_db close];
    return dataArray;
}

@end
