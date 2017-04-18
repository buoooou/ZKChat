//
//  ZKUserEntity.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseEntity.h"

@class UserInfo;

@interface ZKUserEntity : ZKBaseEntity
@property(nonatomic,strong) NSString *name;         //用户名
@property(nonatomic,strong) NSString *nick;         //用户昵称
@property(nonatomic,strong) NSString *avatar;       //用户头像
@property(nonatomic,strong) NSString *signature;   //个性签名
@property(strong)NSString *position;
@property(assign)NSInteger sex;
@property(strong)NSString *telphone;
@property(strong)NSString *email;
@property(strong)NSString *pyname;
@property(assign)NSInteger userStatus;
- (id)initWithUserID:(NSString*)userID name:(NSString*)name nick:(NSString*)nick avatar:(NSString*)avatar userUpdated:(NSUInteger)updated;
+(id)dicToUserEntity:(NSDictionary *)dic;
+(NSMutableDictionary *)userToDic:(ZKUserEntity *)user;
-(void)sendEmail;
-(void)callPhoneNum;
-(NSString *)getAvatarUrl;
-(NSString *)get300AvatarUrl;
-(NSString *)getAvatarPreImageUrl;
-(id)initWithPB:(UserInfo *)pbUser;
+(UInt32)localIDTopb:(NSString *)userid;
+(NSString *)pbUserIdToLocalID:(NSUInteger)userID;

@end
