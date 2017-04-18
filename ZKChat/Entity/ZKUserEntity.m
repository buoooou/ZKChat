//
//  ZKUserEntity.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKUserEntity.h"
#import "NSDictionary+Safe.h"
#import "ZKConfig.h"
#import "IMBuddy.pb.h"


@implementation ZKUserEntity

- (id)initWithUserID:(NSString*)userID name:(NSString*)name nick:(NSString*)nick avatar:(NSString*)avatar userUpdated:(NSUInteger)updated
{
    self = [super init];
    if (self)
    {
        self.objID = [userID copy];
        _name = [name copy];
        _nick = [nick copy];
        _avatar = [avatar copy];
        
        self.lastUpdateTime = updated;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])) {
        self.objID = [aDecoder decodeObjectForKey:@"userId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.nick = [aDecoder decodeObjectForKey:@"nickName"];
        
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.position = [aDecoder decodeObjectForKey:@"position"];
        self.telphone = [aDecoder decodeObjectForKey:@"telphone"];
        
    }
    return self;
    
}

+(NSMutableDictionary *)userToDic:(ZKUserEntity *)user
{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic safeSetObject:user.objID forKey:@"userId"];
    [dic safeSetObject:user.name forKey:@"name"];
    [dic safeSetObject:user.nick forKey:@"nick"];
    [dic safeSetObject:user.avatar forKey:@"avatar"];
    [dic safeSetObject:user.email forKey:@"email"];
    [dic safeSetObject:user.position forKey:@"position"];
    [dic safeSetObject:user.telphone forKey:@"telphone"];
    [dic safeSetObject:[NSNumber numberWithInteger:user.sex] forKey:@"sex"];
    [dic safeSetObject:[NSNumber numberWithLong:user.lastUpdateTime] forKey:@"lastUpdateTime"];
    return dic;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.objID forKey:@"userId"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.nick forKey:@"nick"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.position forKey:@"position"];
    [encoder encodeObject:self.telphone forKey:@"telphone"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.sex ]forKey:@"sex"];
    [encoder encodeObject:[NSNumber numberWithLong:self.lastUpdateTime] forKey:@"lastUpdateTime"];
}
+(id)dicToUserEntity:(NSDictionary *)dic
{
    ZKUserEntity *user = [ZKUserEntity new];
    user.objID = [dic safeObjectForKey:@"userId"];
    user.name = [dic safeObjectForKey:@"name"];
    user.nick = [dic safeObjectForKey:@"nickName"]?[dic safeObjectForKey:@"nickName"]:user.name;
    
    user.avatar = [dic safeObjectForKey:@"avatar"];
    user.email = [dic safeObjectForKey:@"email"];
    user.position = [dic safeObjectForKey:@"position"];
    user.telphone = [dic safeObjectForKey:@"telphone"];
    user.sex = [[dic safeObjectForKey:@"sex"] integerValue];
    user.lastUpdateTime = [[dic safeObjectForKey:@"lastUpdateTime"] integerValue];
    user.pyname = [dic safeObjectForKey:@"pyname"];
    user.signature = [dic safeObjectForKey:@"signature"];
    return user;
    
}
-(void)sendEmail
{
    NSString *stringURL =[NSString stringWithFormat:@"mailto:%@",self.email];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSDictionary *dic=[[NSDictionary alloc]init];
    [[UIApplication sharedApplication] openURL:url options:dic completionHandler:nil];
}
-(void)callPhoneNum
{
    NSString *string = [NSString stringWithFormat:@"tel:%@",self.telphone];
    NSDictionary *dic=[[NSDictionary alloc]init];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:dic completionHandler:nil];
}
- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }else if([self class] != [other class])
    {
        return NO;
    }else {
        ZKUserEntity *otherUser = (ZKUserEntity *)other;
        if (![otherUser.objID isEqualToString:self.objID]) {
            return NO;
        }
        if (![otherUser.name isEqualToString:self.name]) {
            return NO;
        }
        if (![otherUser.nick isEqualToString:self.nick]) {
            return NO;
        }
        if (![otherUser.pyname isEqualToString:self.pyname]) {
            return NO;
        }
    }
    return YES;
}
- (NSUInteger)hash
{
    NSUInteger objIDHash = [self.objID hash];
    NSUInteger nameHash = [self.name hash];
    NSUInteger nickHash = [self.nick hash];
    NSUInteger pynameHash = [self.pyname hash];
    
    return objIDHash^nameHash^nickHash^pynameHash;
}
+(NSString *)pbUserIdToLocalID:(NSUInteger)userID
{
    return [NSString stringWithFormat:@"%@%ld",USER_PRE,userID];
}
+(UInt32)localIDTopb:(NSString *)userid
{
    if (![userid hasPrefix:USER_PRE]) {
        return 0;
    }
    return [[userid substringFromIndex:[USER_PRE length]] integerValue];
}
-(id)initWithPB:(UserInfo *)pbUser
{
    self = [super init];
    if (self) {
        self.objID = [[self class] pbUserIdToLocalID:pbUser.userId];
        self.name  = pbUser.userRealName;
        self.nick  = pbUser.userNickName;
        self.avatar= pbUser.avatarUrl;
        self.telphone = pbUser.userTel;
        self.sex =   pbUser.userGender;
        self.email = pbUser.email;
        self.pyname = pbUser.userDomain;
        self.userStatus = pbUser.status;
        self.signature = pbUser.signInfo;
    }
    return self;
}
-(NSString *)getAvatarUrl
{
    return [NSString stringWithFormat:@"%@_100x100.jpg",self.avatar];
}
-(NSString *)get300AvatarUrl
{
    return [NSString stringWithFormat:@"%@_310x310.jpg",self.avatar];
}
-(NSString *)getAvatarPreImageUrl
{
    return [NSString stringWithFormat:@"%@_640×999.jpg",self.avatar];
}
@end
