//
//  ZKEmotionsViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/3.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"
@protocol ZKEmotionsViewControllerDelegate<NSObject>

- (void)emotionViewClickSendButton;

@end
@interface ZKEmotionsViewController : ZKBaseViewController<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(strong)NSArray *emotions;
@property(assign)BOOL isOpen;
@property(nonatomic,assign)id<ZKEmotionsViewControllerDelegate>delegate;
@end
