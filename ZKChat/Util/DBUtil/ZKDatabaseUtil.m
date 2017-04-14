//
//  ZKDatabaseUtil.m
//  ZKChat
//
//  Created by 张阔 on 2017/4/10.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKDatabaseUtil.h"
#import "ZKConstant.h"
#import "ZKUtil.h"
#import "NSString+DDPath.h"
#import "RuntimeStatus.h"


#define DB_FILE_NAME                    @"tt.sqlite"
#define TABLE_MESSAGE                   @"message"
#define TABLE_ALL_CONTACTS              @"allContacts"
#define TABLE_GROUPS                    @"groups"
#define TABLE_RECENT_SESSION            @"recentSession"

#define SQL_CREATE_MESSAGE              [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (messageID integer,sessionId text ,fromUserId text,toUserId text,content text, status integer, msgTime real, sessionType integer,messageContentType integer,messageType integer,info text,reserve1 integer,reserve2 text,primary key (messageID,sessionId))",TABLE_MESSAGE]

#define SQL_CREATE_ALL_CONTACTS      [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,Name text,Nick text,Avatar text, Department text,DepartID text, Email text,Postion text,Telphone text,Sex integer,updated real,pyname text,signature text)",TABLE_ALL_CONTACTS]

#define SQL_CREATE_GROUPS     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,Avatar text, GroupType integer, Name text,CreatID text,Users Text,LastMessage Text,updated real,isshield integer,version integer)",TABLE_GROUPS]

#define SQL_CREATE_RECENT_SESSION     [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID text UNIQUE,avatar text, type integer, name text,updated real,isshield integer,users Text , unreadCount integer, lasMsg text , lastMsgId integer)",TABLE_RECENT_SESSION]

#define SQL_ADD_CONTACTS_SIGNATURE        [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN signature TEXT",TABLE_ALL_CONTACTS]

@implementation ZKDatabaseUtil
{
    FMDatabase* _database;
    FMDatabaseQueue* _dataBaseQueue;
}
+(instancetype) instance{
    static ZKDatabaseUtil *zkDataBaseUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zkDataBaseUtil =[[ZKDatabaseUtil alloc]init];
    });
    return zkDataBaseUtil;
}

- (void)openCurrentUserDB
{
    if (_database)
    {
        [_database close];
        _database = nil;
    }
    _dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:[ZKDatabaseUtil dbFilePath]];
    _database = [FMDatabase databaseWithPath:[ZKDatabaseUtil dbFilePath]];
    if (![_database open])
    {
        DDLog(@"打开数据库失败");
    }
    else
    {
        // 更新数据库字段增加signature
        if(![_database columnExists:@"signature" inTableWithName:@"allContacts"]){
            // 不存在,需要allContacts增加signature字段
            [_database executeUpdate:SQL_ADD_CONTACTS_SIGNATURE];
            // 版本号变0,全部重新获取用户信息
            __block NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(0) forKey:@"alllastupdatetime"];
        }
        
        // 检查是否需要 重新获取数据
        NSInteger dbVersion = [ZKUtil getDBVersion];
        NSInteger lastDbVersion = [ZKUtil getLastDBVersion];
        if(dbVersion > lastDbVersion){
            // 删除联系人数据 重新获取.
            [self clearTable:TABLE_ALL_CONTACTS];
            [self clearTable:TABLE_GROUPS];
            [self clearTable:TABLE_RECENT_SESSION];
            [ZKUtil setLastDBVersion:dbVersion];
        }
        
        //创建
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            if (![_database tableExists:TABLE_MESSAGE])
            {
                [self createTable:SQL_CREATE_MESSAGE];
            }
            if (![_database tableExists:TABLE_ALL_CONTACTS]) {
                [self createTable:SQL_CREATE_ALL_CONTACTS];
            }
            if (![_database tableExists:TABLE_GROUPS]) {
                [self createTable:SQL_CREATE_GROUPS];
            }
            if (![_database tableExists:TABLE_RECENT_SESSION]) {
                [self createTable:SQL_CREATE_RECENT_SESSION];
            }
        }];
    }
}

+(NSString *)dbFilePath
{
    NSString* directorPath = [NSString userExclusiveDirection];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //改用户的db是否存在，若不存在则创建相应的DB目录
    BOOL isDirector = NO;
    BOOL isExiting = [fileManager fileExistsAtPath:directorPath isDirectory:&isDirector];
    
    if (!(isExiting && isDirector))
    {
        BOOL createDirection = [fileManager createDirectoryAtPath:directorPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        if (!createDirection)
        {
            DDLog(@"创建DB目录失败");
        }
    }
    
    
    NSString *dbPath = [directorPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",TheRuntime.user.objID,DB_FILE_NAME]];
    return dbPath;
}
-(BOOL)createTable:(NSString *)sql          //创建表
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"%@",sql];
    result = [_database executeUpdate:tempSql];
    return result;
}
-(BOOL)clearTable:(NSString *)tableName
{
    BOOL result = NO;
    [_database setShouldCacheStatements:YES];
    NSString *tempSql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    result = [_database executeUpdate:tempSql];
    return result;
}
@end
