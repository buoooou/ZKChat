//
//  ZKAlbumDetailsViewControll.h
//  ZKChat
//
//  Created by 张阔 on 2017/3/21.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"
#import "AQGridView.h"
#import <Photos/Photos.h>
@class ZKAlbumDetailsBottomBar;
@interface ZKAlbumDetailsViewController : ZKBaseViewController<AQGridViewDataSource,AQGridViewDelegate>
@property(nonatomic,strong)PHAssetCollection *assetsCollection;
@property(nonatomic,strong)NSMutableArray *assetsArray;
@property(nonatomic,strong)NSMutableArray *choosePhotosArray;
@property(nonatomic,strong)AQGridView *gridView;
@property(nonatomic,strong)ZKAlbumDetailsBottomBar *bar;

@end
