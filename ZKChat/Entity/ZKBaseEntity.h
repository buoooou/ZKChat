//
//  ZKBaseEntity.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZKBaseEntity : NSObject

@property(assign)long lastUpdateTime;
@property(copy)NSString *objID;
@property(assign)NSInteger objectVersion;
-(NSUInteger)getID;

@end
