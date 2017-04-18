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
#import "ZKUserEntity.h"
#import "ZKGroupEntity.h"
#import "NSDictionary+Safe.h"

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
- (id)init
{
    self = [super init];
    if (self)
    {
        //初始化数据库
        [self openCurrentUserDB];
    }
    return self;
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

- (NSArray*)messageFromSearchResult:(FMResultSet*)resultSet
{
    NSUInteger count = [resultSet intForColumn:@"count(*)"];
    ZKMessageEntity* messageEntity=[self messageFromResult:resultSet];
    return [NSArray arrayWithObjects:@(count),messageEntity, nil];
}

- (ZKMessageEntity*)messageFromResult:(FMResultSet*)resultSet
{
    
    NSString* sessionID = [resultSet stringForColumn:@"sessionId"];
    NSString* fromUserId = [resultSet stringForColumn:@"fromUserId"];
    NSString* toUserId = [resultSet stringForColumn:@"toUserId"];
    NSString* content = [resultSet stringForColumn:@"content"];
    NSTimeInterval msgTime = [resultSet doubleForColumn:@"msgTime"];
    MsgType messageType = [resultSet intForColumn:@"messageType"];
    NSUInteger messageContentType = [resultSet intForColumn:@"messageContentType"];
    NSUInteger messageID = [resultSet intForColumn:@"messageID"];
    NSUInteger messageState = [resultSet intForColumn:@"status"];
    
    ZKMessageEntity* messageEntity = [[ZKMessageEntity alloc] initWithMsgID:messageID
                                                                    msgType:messageType
                                                                    msgTime:msgTime
                                                                  sessionID:sessionID
                                                                   senderID:fromUserId
                                                                 msgContent:content
                                                                   toUserID:toUserId];
    messageEntity.state = messageState;
    messageEntity.msgContentType = messageContentType;
    NSString* infoString = [resultSet stringForColumn:@"info"];
    if (infoString)
    {
        NSData* infoData = [infoString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
        NSMutableDictionary* mutalInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        messageEntity.info = mutalInfo;
        
    }
    return messageEntity;
}

- (ZKUserEntity*)userFromResult:(FMResultSet*)resultSet
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic safeSetObject:[resultSet stringForColumn:@"Name"] forKey:@"name"];
    [dic safeSetObject:[resultSet stringForColumn:@"Nick"] forKey:@"nickName"];
    [dic safeSetObject:[resultSet stringForColumn:@"ID"] forKey:@"userId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Department"] forKey:@"department"];
    [dic safeSetObject:[resultSet stringForColumn:@"Postion"] forKey:@"position"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"Sex"]] forKey:@"sex"];
    [dic safeSetObject:[resultSet stringForColumn:@"DepartID"] forKey:@"departId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Telphone"] forKey:@"telphone"];
    [dic safeSetObject:[resultSet stringForColumn:@"Avatar"] forKey:@"avatar"];
    [dic safeSetObject:[resultSet stringForColumn:@"Email"] forKey:@"email"];
    [dic safeSetObject:@([resultSet longForColumn:@"updated"]) forKey:@"lastUpdateTime"];
    [dic safeSetObject:[resultSet stringForColumn:@"pyname"] forKey:@"pyname"];
    [dic safeSetObject:[resultSet stringForColumn:@"signature"] forKey:@"signature"];
    ZKUserEntity* user = [ZKUserEntity dicToUserEntity:dic];
    return user;
}

-(ZKGroupEntity *)groupFromResult:(FMResultSet *)resultSet
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic safeSetObject:[resultSet stringForColumn:@"Name"] forKey:@"name"];
    [dic safeSetObject:[resultSet stringForColumn:@"ID"] forKey:@"groupId"];
    [dic safeSetObject:[resultSet stringForColumn:@"Avatar"] forKey:@"avatar"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"GroupType"]] forKey:@"groupType"];
    [dic safeSetObject:@([resultSet longForColumn:@"updated"]) forKey:@"lastUpdateTime"];
    [dic safeSetObject:[resultSet stringForColumn:@"CreatID"] forKey:@"creatID"];
    [dic safeSetObject:[resultSet stringForColumn:@"Users"] forKey:@"Users"];
    [dic safeSetObject:[resultSet stringForColumn:@"LastMessage"] forKey:@"lastMessage"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"isshield"]] forKey:@"isshield"];
    [dic safeSetObject:[NSNumber numberWithInt:[resultSet intForColumn:@"version"]] forKey:@"version"];
    ZKGroupEntity* group = [ZKGroupEntity dicToZKGroupEntity:dic];
    
    return group;
}

#pragma mark message
- (void)loadMessageForSessionID:(NSString*)sessionID pageCount:(int)pagecount index:(NSInteger)index completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM message where sessionId=? ORDER BY msgTime DESC limit ?,?"];
            FMResultSet* result = [_database executeQuery:sqlString,sessionID,[NSNumber numberWithInteger:index],[NSNumber numberWithInteger:pagecount]];
            while ([result next])
            {
                ZKMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(array,nil);
            });
        }
    }];
}

- (void)loadMessageForSessionID:(NSString*)sessionID afterMessage:(ZKMessageEntity*)message completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select * from %@ where sessionId = '%@' AND messageID >= ? order by msgTime DESC,messageID DESC",TABLE_MESSAGE,sessionID];
            FMResultSet* result = [_database executeQuery:sqlString,@(message.msgID)];
            while ([result next])
            {
                ZKMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)searchHistory:(NSString *)key completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select count(*),* from %@ where content like '%%%@%%' and content not like '%%&$#@~^@[{:%%' GROUP BY sessionId",TABLE_MESSAGE,key];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                NSArray* message = [self messageFromSearchResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)searchHistoryBySessionId:(NSString *)key sessionId:(NSString *)sessionId completion:(LoadMessageInSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"select * from %@ where content like '%%%@%%' and sessionId = '%@' and content not like '%%&$#@~^@[{:%%'",TABLE_MESSAGE,key,sessionId];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                ZKMessageEntity* message = [self messageFromResult:result];
                [array addObject:message];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)getLasetCommodityTypeImageForSession:(NSString*)sessionID completion:(DDGetLastestCommodityMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * from %@ where sessionId=? AND messageType = ? ORDER BY msgTime DESC,rowid DESC limit 0,1",TABLE_MESSAGE];
            FMResultSet* result = [_database executeQuery:sqlString,sessionID,@(4)];
            ZKMessageEntity* message = nil;
            while ([result next])
            {
                message = [self messageFromResult:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(message);
            });
        }
    }];
}

- (void)getLastestMessageForSessionID:(NSString*)sessionID completion:(DDDBGetLastestMessageCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where sessionId=? and status = 2 ORDER BY messageId DESC limit 0,1",TABLE_MESSAGE];
            
            FMResultSet* result = [_database executeQuery:sqlString,sessionID];
            ZKMessageEntity* message = nil;
            while ([result next])
            {
                message = [self messageFromResult:result];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(message,nil);
                });
                
                break;
            }
            if(message == nil){
                completion(message,nil);
            }
        }
    }];
}



- (void)getMessagesCountForSessionID:(NSString*)sessionID completion:(MessageCountCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_MESSAGE])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sessionId=?",TABLE_MESSAGE];
            
            FMResultSet* result = [_database executeQuery:sqlString,sessionID];
            int count = 0;
            while ([result next])
            {
                count = [result intForColumnIndex:0];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(count);
            });
        }
    }];
}

- (void)insertMessages:(NSArray*)messages
               success:(void(^)())success
               failure:(void(^)(NSString* errorDescripe))failure
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ZKMessageEntity* message = (ZKMessageEntity*)obj;
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_MESSAGE];
                
                NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:message.info options:NSJSONWritingPrettyPrinted error:nil];
                NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
                
                BOOL result = [_database executeUpdate:sql,@(message.msgID),message.sessionId,message.senderId,message.toUserID,message.msgContent,@(message.state),@(message.msgTime),@(1),@(message.msgContentType),@(message.msgType),json,@(0),@""];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
            failure(@"插入数据失败");
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                failure(@"插入数据失败");
            }
            else
            {
                [_database commit];
                success();
            }
        }
    }];
}

- (void)deleteMesagesForSession:(NSString*)sessionID completion:(DeleteSessionCompletion)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM message WHERE sessionId = ?";
        BOOL result = [_database executeUpdate:sql,sessionID];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}

- (void)deleteMesages:(ZKMessageEntity * )message completion:(DeleteSessionCompletion)completion
{
    ;
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM message WHERE messageID = ?";
        BOOL result = [_database executeUpdate:sql,@(message.msgID)];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}

- (void)updateMessageForMessage:(ZKMessageEntity*)message completion:(DDUpdateMessageCompletion)completion
{
    //(messageID integer,sessionId text,fromUserId text,toUserId text,content text, status integer, msgTime real, sessionType integer,messageType integer,reserve1 integer,reserve2 text)
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = [NSString stringWithFormat:@"UPDATE %@ set sessionId = ? , fromUserId = ? , toUserId = ? , content = ? , status = ? , msgTime = ? , sessionType = ? , messageType = ? ,messageContentType = ? , info = ? where messageID = ?",TABLE_MESSAGE];
        
        NSData* infoJsonData = [NSJSONSerialization dataWithJSONObject:message.info options:NSJSONWritingPrettyPrinted error:nil];
        NSString* json = [[NSString alloc] initWithData:infoJsonData encoding:NSUTF8StringEncoding];
        BOOL result = [_database executeUpdate:sql,message.sessionId,message.senderId,message.toUserID,message.msgContent,@(message.state),@(message.msgTime),@(message.sessionType),@(message.msgType),@(message.msgContentType),json,@(message.msgID)];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result);
        });
    }];
}
#pragma mark - Users

- (void)insertAllUser:(NSArray*)users completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            
            [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ZKUserEntity* user = (ZKUserEntity *)obj;
                if (user.userStatus == 3) {
                    user.telphone=@"";
                    user.email = @"";
                    user.name=@"";
                }
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_ALL_CONTACTS];
                //ID,Name,Nick,Avatar,Role,updated,reserve1,reserve2
                BOOL result = [_database executeUpdate:sql,user.objID,user.name,user.nick,user.avatar,user.departId,user.email,user.position,user.telphone,@(user.sex),user.lastUpdateTime,user.pyname,user.signature];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
                
                
            }];
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"批量插入全部用户信息失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
        }
    }];
}

- (void)getAllUsers:(LoadAllContactsComplection )completion
{
    
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_ALL_CONTACTS])
        {
            [_database setShouldCacheStatements:YES];
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",TABLE_ALL_CONTACTS];
            FMResultSet* result = [_database executeQuery:sqlString];
            ZKUserEntity* user = nil;
            while ([result next])
            {
                user = [self userFromResult:result];
                if (user.userStatus != 3) {
                    [array addObject:user];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)getUserFromID:(NSString*)userID completion:(void(^)(ZKUserEntity *user))completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([_database tableExists:TABLE_ALL_CONTACTS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where ID= ?",TABLE_ALL_CONTACTS];
            
            FMResultSet* result = [_database executeQuery:sqlString,userID];
            
            ZKUserEntity* user = nil;
            while ([result next])
            {
                user = [self userFromResult:result];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(user);
            });
        }
    }];
}
- (void)loadGroupByIDCompletion:(NSString *)groupID Block:(LoadRecentContactsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_GROUPS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ where ID= ? ",TABLE_GROUPS];
            FMResultSet* result = [_database executeQuery:sqlString,groupID];
            while ([result next])
            {
                ZKGroupEntity* group = [self groupFromResult:result];
                [array addObject:group];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)loadGroupsCompletion:(LoadRecentContactsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_GROUPS])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_GROUPS];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                ZKGroupEntity* group = [self groupFromResult:result];
                [array addObject:group];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(array,nil);
            });
        }
    }];
}

- (void)updateRecentGroup:(ZKGroupEntity *)group completion:(InsertsRecentContactsCOmplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",TABLE_GROUPS];
            NSString *users = @"";
            if ([group.groupUserIds count]>0) {
                users=[group.groupUserIds componentsJoinedByString:@"-"];
            }
            BOOL result = [_database executeUpdate:sql,group.objID,group.avatar,@(group.groupType),group.name,group.groupCreatorId,users,group.lastMsg,@(group.lastUpdateTime),@(group.isShield),@(group.objectVersion)];
            if (!result)
            {
                isRollBack = YES;
            }
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近群失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }
    }];
}

- (void)updateRecentSessions:(NSArray *)sessions completion:(InsertsRecentContactsCOmplection)completion{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        
        [_database beginTransaction];
        
        __block BOOL isRollBack = NO;
        @try {
            
            [sessions enumerateObjectsUsingBlock:^(ZKSessionEntity *session, NSUInteger idx, BOOL *stop) {
                
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",TABLE_RECENT_SESSION];
                //ID Avatar GroupType Name CreatID Users  LastMessage
                NSString *users = @"";
                if ([session.sessionUsers count]>0) {
                    users=[session.sessionUsers componentsJoinedByString:@"-"];
                }
                BOOL result = [_database executeUpdate:sql,session.sessionID,session.avatar,@(session.sessionType),session.name,@(session.timeInterval),@(session.isShield),users,@(session.unReadMsgCount),session.lastMsg,@(session.lastMsgID)];
                
                if (!result)
                {
                    isRollBack = YES;
                    *stop = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近Session失败" code:0 userInfo:nil];
                //                completion(error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
            else
            {
                [_database commit];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
        }
    }];
}

- (void)updateRecentSession:(ZKSessionEntity *)session completion:(InsertsRecentContactsCOmplection)completion{
    /*
     ID text UNIQUE,Avatar text, Type integer, Name text,LastMessage Text,updated real,isshield intege  Users Text
     */
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        [_database beginTransaction];
        __block BOOL isRollBack = NO;
        @try {
            NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ VALUES(?,?,?,?,?,?,?,?,?,?)",TABLE_RECENT_SESSION];
            //ID Avatar GroupType Name CreatID Users  LastMessage
            NSString *users = @"";
            if ([session.sessionUsers count]>0) {
                users=[session.sessionUsers componentsJoinedByString:@"-"];
            }
            BOOL result = [_database executeUpdate:sql,session.sessionID,session.avatar,@(session.sessionType),session.name,@(session.timeInterval),@(session.isShield),users,@(session.unReadMsgCount),session.lastMsg,@(session.lastMsgID)];
            if (!result)
            {
                isRollBack = YES;
            }
            
        }
        @catch (NSException *exception) {
            [_database rollback];
        }
        @finally {
            if (isRollBack)
            {
                [_database rollback];
                DDLog(@"insert to database failure content");
                NSError* error = [NSError errorWithDomain:@"插入最近Session失败" code:0 userInfo:nil];
                completion(error);
            }
            else
            {
                [_database commit];
                completion(nil);
            }
        }
    }];
}

#pragma session
- (void)loadSessionsCompletion:(LoadAllSessionsComplection)completion
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        if ([_database tableExists:TABLE_RECENT_SESSION])
        {
            [_database setShouldCacheStatements:YES];
            
            NSString* sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ order BY updated DESC",TABLE_RECENT_SESSION];
            FMResultSet* result = [_database executeQuery:sqlString];
            while ([result next])
            {
                ZKSessionEntity* session = [self sessionFromResult:result];
                [array addObject:session];
            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            completion(array,nil);
            //            });
        }
    }];
}

-(ZKSessionEntity *)sessionFromResult:(FMResultSet *)resultSet
{
    /*
     ID text UNIQUE,Avatar text, Type integer, Name text,updated real,isshield integer,Users Text
     */
    SessionType type =(SessionType)[resultSet intForColumn:@"type"];
    ZKSessionEntity* session = [[ZKSessionEntity alloc] initWithSessionID:[resultSet stringForColumn:@"ID"] SessionName:[resultSet stringForColumn:@"name"] type:type];
    session.avatar=[resultSet stringForColumn:@"avatar"];
    session.timeInterval=[resultSet longForColumn:@"updated"];
    session.lastMsg = [resultSet stringForColumn:@"lasMsg"];
    session.lastMsgID = [resultSet longForColumn:@"lastMsgId"];
    session.unReadMsgCount = [resultSet longForColumn:@"unreadCount"];
    return session;
}
-(void)removeSession:(NSString *)sessionID
{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString* sql = @"DELETE FROM recentSession WHERE ID = ?";
        BOOL result = [_database executeUpdate:sql,sessionID];
        if(result)
        {
            NSString* sql = @"DELETE FROM message WHERE sessionId = ?";
            BOOL result = [_database executeUpdate:sql,sessionID];
        }
    }];
    
}

@end
