//
//  ZKBaseEntity.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/26.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseEntity.h"

@implementation ZKBaseEntity
-(NSUInteger)getID
{
    NSArray *array = [self.objID componentsSeparatedByString:@"_"];
    if (array[1]) {
        return [array[1] intValue];
    }
    return 0;
}
@end
