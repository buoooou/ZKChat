//
//  ZKAlbumDetailsBottomBar.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/21.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonSelectBlock)(int buttonIndex) ;
@interface ZKAlbumDetailsBottomBar : UIView
@property(nonatomic,strong)UIButton *send;
@property(nonatomic,copy)ButtonSelectBlock Block;

-(void)setSendButtonTitle:(int)num;
@end
