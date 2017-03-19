//
//  ZKChattingImagePreviewViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseViewController.h"
#import "LCActionSheet.h"
#import "MWPhotoBrowser.h"
@interface ZKChattingImagePreviewViewController : ZKBaseViewController<MWPhotoBrowserDelegate,LCActionSheetDelegate>
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic)NSInteger index;
@property(nonatomic)NSString *QRCodeResult;
@property(strong)UIImage *previewImage;
@end
