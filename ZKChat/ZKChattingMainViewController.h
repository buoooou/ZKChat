//
//  ZKChattingMainViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKBaseTableViewController.h"
#import "ChattingModule.h"
#import "ZKEmotionsViewController.h"
#import "ZKPhotosCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZKChattingUtilityViewController.h"
#import "JSMessageInputView.h"

@class RecordingView;

typedef void(^TimeCellAddBlock)(bool isok);

@interface ZKChattingMainViewController : ZKBaseTableViewController<UITextViewDelegate, JSMessageInputViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,ZKEmotionsViewControllerDelegate,UINavigationControllerDelegate>{
    RecordingView* _recordingView;
}
+(instancetype )shareInstance;
@property(nonatomic,strong)ChattingModule* module;
@property(nonatomic,strong)ZKChattingUtilityViewController *ddUtility;
@property(nonatomic,strong)JSMessageInputView *chatInputView;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property(nonatomic,strong)ZKEmotionsViewController *emotions;
@property (assign, nonatomic, readonly) UIEdgeInsets originalTableViewContentInset;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) UIImageView* preShow;
@property (nonatomic, strong) ALAsset *lastPhoto;
@property (nonatomic, strong) ZKPhotoEnity *preShowPhoto;
@property (nonatomic, strong) UIImage *preShowImage;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (assign)BOOL hadLoadHistory;
// 去@页面
@property (assign)BOOL isGotoAt;


- (void)sendImageMessage:(ZKPhotoEnity *)photo Image:(UIImage *)image;
- (void)sendPrompt:(NSString*)prompt;
-(void)removeImage;
/**
 *  任意页面跳转到聊天界面并开始一个会话
 *
 *  @param session 传入一个会话实体
 */
- (void)loadChattingContentFromSearch:(ZKSessionEntity*)session message:(ZKMessageEntity*)message;
- (void)showChattingContentForSession:(ZKSessionEntity*)session;
- (void)insertEmojiFace:(NSString *)string;
- (void)deleteEmojiFace;
- (void)p_popViewController;
@end
@interface ZKChattingMainViewController(ChattingInput)
- (void)initialInput;
@end
