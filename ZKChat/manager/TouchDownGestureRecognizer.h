//
//  TouchDownGestureRecognizer.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DDTouchDown)();
typedef void(^DDTouchMoveOutside)();
typedef void(^DDTouchMoveInside)();
typedef void(^DDTouchEnd)(BOOL inside);
@interface TouchDownGestureRecognizer : UIGestureRecognizer
@property (nonatomic,copy) DDTouchDown touchDown;
@property (nonatomic,copy) DDTouchMoveOutside moveOutside;
@property (nonatomic,copy) DDTouchMoveInside moveInside;
@property (nonatomic,copy) DDTouchEnd touchEnd;

@end
