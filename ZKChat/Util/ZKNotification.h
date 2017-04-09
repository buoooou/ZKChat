//
//  ZKNotification.h
//  ZKChat
//
//  Created by 张阔 on 2017/4/9.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKNotification : NSObject
+ (void)postNotification:(NSString*)notification userInfo:(NSDictionary*)userInfo object:(id)object;
@end
