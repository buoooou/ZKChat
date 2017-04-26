//
//  ZKConfig.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/22.
//  Copyright © 2017年 张阔. All rights reserved.
//

#ifndef ZKConfig_h
#define ZKConfig_h

#define USER_PRE @"user_"
#define SERVER_ADDR   @""
//-------------------打印--------------------

#ifdef DEBUG
#define NEED_OUTPUT_LOG             1
#define Is_CanSwitchServer          1
#else
#define NEED_OUTPUT_LOG             0
#define Is_CanSwitchServer          0
#endif

#if NEED_OUTPUT_LOG
#define DDLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DDLog(xx, ...)                 nil
#endif

#endif /* ZKConfig_h */
