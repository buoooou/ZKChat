//
//  ZKChattingMainViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/25.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKChattingMainViewController.h"
#import "ZKEmotionsViewController.h"
#import "ZKChattingImagePreviewViewController.h"
#import "ZKConstant.h"
#import "ZKSessionEntity.h"
#import "JSMessageInputView.h"
#import "RecordingView.h"
#import "UIView+Addition.h"
#import "ZKUtil.h"
#import "ZKPublicProfileViewController.h"
#import "ZKChattingEditViewController.h"
#import "ZKMessageEntity.h"
#import "DDChatBaseCell.h"
#import "RuntimeStatus.h"
#import "DDChatTextCell.h"
#import "DDPromptCell.h"

typedef NS_ENUM(NSUInteger, DDBottomShowComponent)
{
    DDInputViewUp                       = 1,
    DDShowKeyboard                      = 1 << 1,
    DDShowEmotion                       = 1 << 2,
    DDShowUtility                       = 1 << 3
};

typedef NS_ENUM(NSUInteger, DDBottomHiddComponent)
{
    DDInputViewDown                     = 14,
    DDHideKeyboard                      = 13,
    DDHideEmotion                       = 11,
    DDHideUtility                       = 7
};
//

typedef NS_ENUM(NSUInteger, DDInputType)
{
    DDVoiceInput,
    DDTextInput
};

typedef NS_ENUM(NSUInteger, PanelStatus)
{
    VoiceStatus,
    TextInputStatus,
    EmotionStatus,
    ImageStatus
};

#define DDINPUT_MIN_HEIGHT          44.0f
#define DDINPUT_HEIGHT              self.chatInputView.size.height
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, CONTENT_HEIGHT - self.chatInputView.height + NAVBAR_HEIGHT,FULL_WIDTH,self.chatInputView.height)
#define DDINPUT_TOP_FRAME           CGRectMake(0, CONTENT_HEIGHT - self.chatInputView.height + NAVBAR_HEIGHT - 216, FULL_WIDTH, self.chatInputView.height)
#define DDUTILITY_FRAME             CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT -216, FULL_WIDTH, 216)
#define DDEMOTION_FRAME             CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT-216, FULL_WIDTH, 216)
#define DDCOMPONENT_BOTTOM          CGRectMake(0, CONTENT_HEIGHT + NAVBAR_HEIGHT, FULL_WIDTH, 216)


@interface ZKChattingMainViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)CGPoint inputViewCenter;
@property(nonatomic,assign)BOOL ifScrollBottom;
@property(assign)PanelStatus panelStatus;
@property(strong)NSString *chatObjectID;


- (UITableViewCell*)p_textCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(ZKMessageEntity*)message;
- (UITableViewCell*)p_voiceCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(ZKMessageEntity*)message;
//- (UITableViewCell*)p_promptCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(DDPromptEntity*)prompt;

- (void)n_receiveMessage:(NSNotification*)notification;
- (void)p_clickThRecordButton:(UIButton*)button;
- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;

- (void)p_tapOnTableView:(UIGestureRecognizer*)sender;
- (void)p_hideBottomComponent;

- (void)p_enableChatFunction;
- (void)p_unableChatFunction;
@end

@implementation ZKChattingMainViewController
{
//    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    NSString* _currentInputContent;
    UIButton *_recordButton;
    DDBottomShowComponent _bottomShowComponent;
    float _inputViewY;
    int _type;
}
+(instancetype )shareInstance
{
    static dispatch_once_t onceToken;
    static ZKChattingMainViewController *_sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [ZKChattingMainViewController new];
    });
    return _sharedManager;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewStyle = UITableViewStyleGrouped;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
-(void)notificationCenter
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(n_receiveMessage:)
//                                                 name:DDNotificationReceiveMessage
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reloginSuccess)
//                                                 name:@"ReloginSuccess"
//                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self notificationCenter];
    [self initialInput];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
    //                                                                          action:@selector(p_tapOnTableView:)];
    //    [self.tableView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(p_tapOnTableView:)];
    pan.delegate = self;
    [self.tableView addGestureRecognizer:pan];
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ZKRefreshViewHeight)];
    [headView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:headView];

    [self scrollToBottomAnimated:NO];
    
//    [self initScrollView];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"myprofile"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(Edit:)];
    self.navigationItem.rightBarButtonItem=item;
    [self.module addObserver:self
                  forKeyPath:@"showingMessages"
                     options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                     context:NULL];
//    [self.module addObserver:self
//                  forKeyPath:@"ZKSessionEntity.sessionID"
//                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
//                     context:NULL];
    [self.navigationItem.titleView setUserInteractionEnabled:YES];
    self.view.backgroundColor=ZKBG;
    
    if([TheRuntime.user.nick isEqualToString:@"蝎紫"]){
        UIImageView *chatBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [chatBgView setImage:[UIImage imageNamed:@"chatBg"]];
        [self.view insertSubview:chatBgView atIndex:0];
        self.tableView.backgroundView =chatBgView;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.isGotoAt = NO;
    self.ifScrollBottom = YES;

    
}
- (ChattingModule*)module
{
    if (!_module)
    {
        _module = [[ChattingModule alloc] init];
    }
    return _module;
}

- (void)textViewEnterSend
{
    //发送消息
    NSString* text = [self.chatInputView.textView text];
    
    NSString* parten = @"\\s";
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSString* checkoutText = [reg stringByReplacingMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, [text length]) withTemplate:@""];
    if ([checkoutText length] == 0)
    {
        return;
    }
    DDMessageContentType msgContentType = DDMessageTypeText;
    ZKMessageEntity *message = [ZKMessageEntity makeMessage:text Module:self.module MsgType:msgContentType];
    
    [self.tableView reloadData];
    [self.chatInputView.textView setText:nil];
//    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
//        DDLog(@"消息插入DB成功");
//    } failure:^(NSString *errorDescripe) {
//        DDLog(@"消息插入DB失败");
//    }];
    [self sendMessage:text messageEntity:message];
}

-(void)sendMessage:(NSString *)msg messageEntity:(ZKMessageEntity *)message
{
    //    BOOL isGroup = [self.module.ZKSessionEntity isGroup];
    //    [[DDMessageSendManager instance] sendMessage:message isGroup:isGroup Session:self.module.MTTSessionEntity  completion:^(ZKMessageEntity* theMessage,NSError *error) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            message.state= theMessage.state;
    //            [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
    //        });
    //    } Error:^(NSError *error) {
    //        [self.tableView reloadData];
    //    }];
}


-(void)Edit:(id)sender
{
    ZKChattingEditViewController *chattingedit = [ZKChattingEditViewController new];
    chattingedit.session=self.module.ZKSessionEntity;
    self.title=@"";
    [self pushViewController:chattingedit animated:YES];
}
- (void)p_tapOnTableView:(UIGestureRecognizer*)sender
{
    [self removeImage];
    if (_bottomShowComponent)
    {
        [self p_hideBottomComponent];
    }
}
-(void)removeImage
{
    _lastPhoto = nil;
    [_preShow removeFromSuperview];
}
- (void)p_hideBottomComponent
{
    _bottomShowComponent = _bottomShowComponent & 0;
    //隐藏所有
    
    [self.chatInputView.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.chatInputView setFrame:DDINPUT_BOTTOM_FRAME];
    }];
    
    [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.isGotoAt){
        [self.chatInputView.textView setText:nil];
    }
    self.isGotoAt = NO;
    
    //self.tableView.noMore =NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.chatInputView.textView setEditable:YES];
    
    [self.navigationController.navigationBar setHidden:NO];
    if (self.ddUtility != nil)
    {
       // NSString *sessionId = self.module.ZKSessionEntity.sessionID;
//        self.ddUtility.userId = [ZKUserEntity localIDTopb:sessionId];
        self.ddUtility.userId = [ZKUserEntity localIDTopb:@"sdf"];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.module.ids removeAllObjects];
    
    //    [[PlayerManager sharedManager] stopPlaying];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(!self.isGotoAt){
        [super viewDidDisappear:animated];
        [self.chatInputView.textView setEditable:NO];
    }
    
}
#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.module.showingMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    id object = self.module.showingMessages[indexPath.row];
    if ([object isKindOfClass:[ZKMessageEntity class]])
    {
        ZKMessageEntity* message = object;
        height = [self.module messageHeight:message];
    }
    return height+10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id object = self.module.showingMessages[indexPath.row];
    UITableViewCell* cell = nil;
    if ([object isKindOfClass:[ZKMessageEntity class]])
    {
        ZKMessageEntity* message = (ZKMessageEntity*)object;
//        if (message.msgContentType == DDMessageTypeText ) {
            cell = [self p_textCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
//        }else if (message.msgContentType == DDMessageTypeVoice)
//        {
//            cell = [self p_voiceCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
//        }
//        else if(message.msgContentType == DDMessageTypeImage)
//        {
//            cell = [self p_imageCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
//        }else if (message.msgContentType == DDMEssageEmotion)
//        {
//            cell = [self p_emotionCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
//        }
//        else
//        {
//            cell = [self p_textCell_tableView:tableView cellForRowAtIndexPath:indexPath message:message];
//        }
//        
    }
    else if ([object isKindOfClass:[DDPromptEntity class]])
    {
        DDPromptEntity* prompt = (DDPromptEntity*)object;
        cell = [self p_promptCell_tableView:tableView cellForRowAtIndexPath:indexPath message:prompt];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y + self.tableView.height >= self.tableView.contentSize.height - 100){
        self.ifScrollBottom = YES;
    }else{
        self.ifScrollBottom = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 上拉弹出键盘
    //    if (scrollView.contentOffset.y < scrollView.contentSize.height -scrollView.frame.size.height +scrollView.contentInset.bottom){
    //        [self p_hideBottomComponent];
    //    }
    //    else if (scrollView.contentOffset.y > scrollView.contentSize.height -scrollView.frame.size.height +scrollView.contentInset.bottom +80) {
    //            [self.chatInputView.textView becomeFirstResponder];
    //    }
}

#pragma mark PrivateAPI

- (UITableViewCell*)p_promptCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(DDPromptEntity*)prompt
{
    static NSString* identifier = @"DDPromptCellIdentifier";
    DDPromptCell* cell = (DDPromptCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDPromptCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString* promptMessage = prompt.message;
    [cell setprompt:promptMessage];
    return cell;
}

- (UITableViewCell*)p_textCell_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath message:(ZKMessageEntity*)message
{
    static NSString* identifier = @"DDChatTextCellIdentifier";
    DDChatBaseCell* cell = (DDChatBaseCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDChatTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentLabel.delegate = self;
    }
    cell.session =self.module.ZKSessionEntity;
//    NSString* myUserID = [RuntimeStatus instance].user.objID;
//    if ([message.senderId isEqualToString:myUserID])
//    {
//        [cell setLocation:DDBubbleRight];
//    }
//    else
//    {
        [cell setLocation:DDBubbleRight];
//    }
    
//    if (![[UnAckMessageManager instance] isInUnAckQueue:message] && message.state == DDMessageSending && [message isSendBySelf]) {
//        message.state=DDMessageSendFailure;
//    }
//    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
//        
//    }];
    
    [cell setContent:message];
    __weak DDChatTextCell* weakCell = (DDChatTextCell*)cell;
    cell.sendAgain = ^{
        [weakCell showSending];
        [weakCell sendTextAgain:message];
    };
    
    return cell;
}

@end

@implementation ZKChattingMainViewController(ChattingInput)

- (void)initialInput
{
    CGRect inputFrame = CGRectMake(0, CONTENT_HEIGHT - DDINPUT_MIN_HEIGHT + NAVBAR_HEIGHT,FULL_WIDTH,DDINPUT_MIN_HEIGHT);
    self.chatInputView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    [self.chatInputView setBackgroundColor:RGBA(249, 249, 249, 0.9)];
    [self.view addSubview:self.chatInputView];
    [self.chatInputView.emotionbutton addTarget:self
                                         action:@selector(showEmotions:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatInputView.showUtilitysbutton addTarget:self
                                              action:@selector(showUtilitys:)
                                    forControlEvents:UIControlEventTouchDown];
    
    [self.chatInputView.voiceButton addTarget:self
                                       action:@selector(p_clickThRecordButton:)
                             forControlEvents:UIControlEventTouchUpInside];
    
    
//    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
//    __weak ZKChattingMainViewController* weakSelf = self;
//    _touchDownGestureRecognizer.touchDown = ^{
//        [weakSelf p_record:nil];
//    };
//    
//    _touchDownGestureRecognizer.moveInside = ^{
//        [weakSelf p_endCancelRecord:nil];
//    };
//    
//    _touchDownGestureRecognizer.moveOutside = ^{
//        [weakSelf p_willCancelRecord:nil];
//    };
//    
//    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
//        if (inside)
//        {
//            [weakSelf p_sendRecord:nil];
//        }
//        else
//        {
//            [weakSelf p_cancelRecord:nil];
//        }
//    };
//    [self.chatInputView.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(FULL_WIDTH/2, self.view.centerY)];
//    [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}
- (void)p_clickThRecordButton:(UIButton*)button
{
    switch (button.tag) {
        case DDVoiceInput:
            //开始录音
            [self p_hideBottomComponent];
            [button setImage:[UIImage imageNamed:@"input_normal"] forState:UIControlStateNormal];
            button.tag = DDTextInput;
            [self.chatInputView willBeginRecord];
            [self.chatInputView.textView resignFirstResponder];
            _currentInputContent = self.chatInputView.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:nil];
            }
            break;
        case DDTextInput:
            //开始输入文字
            [button setImage:[UIImage imageNamed:@"record_normal"] forState:UIControlStateNormal];
            button.tag = DDVoiceInput;
            [self.chatInputView willBeginInput];
            if ([_currentInputContent length] > 0)
            {
                [self.chatInputView.textView setText:_currentInputContent];
            }
            [self.chatInputView.textView becomeFirstResponder];
            break;
    }
}

#pragma JSMessageInputViewDelegate
- (void)viewheightChanged:(float)height
{
    [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
}
- (void)textViewChanged
{
    NSRange range = self.chatInputView.textView.selectedRange;
    NSInteger location = range.location;
    __block NSString* text = [self.chatInputView.textView text];
    if(location){
        __block NSRange range = NSMakeRange(location-1, 1);
        NSString* lastText =  [text substringWithRange:range];
//        if([lastText isEqualToString:@"@"]){
//            self.isGotoAt = YES;
//            ContactsViewController *contact = [ContactsViewController new];
//            contact.isFromAt=YES;
//            contact.selectUser =^(MTTUserEntity *user){
//                NSString *atName = [NSString stringWithFormat:@"@%@ ",user.nick];
//                text = [text stringByReplacingCharactersInRange:range withString:atName];
//                [self.chatInputView.textView setText:text];
//            };
//            [self.navigationController pushViewController:contact animated:YES];
//        }
    }
}
-(void)showUtilitys:(id)sender
{
    [_recordButton setImage:[UIImage imageNamed:@"record_normal"] forState:UIControlStateNormal];
    _recordButton.tag = DDVoiceInput;
    [self.chatInputView willBeginInput];
    if ([_currentInputContent length] > 0)
    {
        [self.chatInputView.textView setText:_currentInputContent];
    }
    
    if (self.ddUtility == nil)
    {
        self.ddUtility = [ZKChattingUtilityViewController new];
//        NSString *sessionId = self.module.ZKSessionEntity.sessionID;
        NSString *sessionId =@"zk";
        if(self.module.isGroup){
            self.ddUtility.userId = 0;
        }else{
            self.ddUtility.userId = [ZKUserEntity localIDTopb:sessionId];
        }
        [self addChildViewController:self.ddUtility];
        self.ddUtility.view.frame=CGRectMake(0, self.view.size.height,FULL_WIDTH , 280);
        [self.view addSubview:self.ddUtility.view];
    }
    
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
        [self.chatInputView.textView resignFirstResponder];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //插件面板本来就是显示的,这时需要隐藏所有底部界面
        //        [self p_hideBottomComponent];
        [self.chatInputView.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideUtility;
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情，这时需要隐藏表情，显示插件
        [self.emotions.view setFrame:DDCOMPONENT_BOTTOM];
        [self.ddUtility.view setFrame:DDUTILITY_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
    }
    else
    {
        //这是什么都没有显示，需用动画显示插件
        _bottomShowComponent = _bottomShowComponent | DDShowUtility;
        [UIView animateWithDuration:0.25 animations:^{
            [self.ddUtility.view setFrame:DDUTILITY_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
    }
    
    // 判断最后一张照片是不是90s内
    
//    ALAssetsLibrary *assetsLibrary;
//    assetsLibrary = [[ALAssetsLibrary alloc] init];
//    __block NSDate *lastDate = [[NSDate alloc] initWithTimeInterval:-90 sinceDate:[NSDate date]];
////    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if (group) {
//            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                if (result) {
//                    NSDate *date= [result valueForProperty:ALAssetPropertyDate];
//                    if ([date compare:lastDate] == NSOrderedDescending) {
//                        lastDate = date;
//                        _lastPhoto = result;
//                    }
//                }
//            }];
//        }else{
//            if(_lastPhoto && ([[ZKUtil getLastPhotoTime] compare:lastDate] != NSOrderedSame)){
//                [ZKUtil setLastPhotoTime:lastDate];
//                //10s后隐藏界面
//                [self performSelector:@selector(removeImage) withObject:nil afterDelay:10];
//                _preShow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT-385, 67, 110)];
//                [_preShow setTag:10000];
//                [_preShow setUserInteractionEnabled:YES];
//                UIImage *preShowBg = [UIImage imageNamed:@"chat_bubble_pre_image"];
//                preShowBg = [preShowBg stretchableImageWithLeftCapWidth:8 topCapHeight:8];
//                [_preShow setImage:preShowBg];
//                
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnPreShow:)];
//                [_preShow addGestureRecognizer:tap];
//                
//                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(4, 5, 60, 30)];
//                [label setText:@"你可能要发送的图片:"];
//                [label setFont:systemFont(12)];
//                [label setNumberOfLines:0];
//                
//                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 40, 60, 60)];
//                UIImage *image=[UIImage imageWithCGImage:_lastPhoto.aspectRatioThumbnail];
//                [imgView setImage:image];
//                [imgView setContentMode:UIViewContentModeScaleAspectFill];
//                [imgView setClipsToBounds:YES];
//                [imgView.layer setBorderColor:RGB(229, 229, 229).CGColor];
//                [imgView.layer setBorderWidth:1];
//                [imgView.layer setCornerRadius:5];
//                [_preShow addSubview:label];
//                [_preShow addSubview:imgView];
//                [self.view addSubview:_preShow];
//                
//                _preShowPhoto = [ZKPhotoEnity new];
//                ALAssetRepresentation* representation = [_lastPhoto defaultRepresentation];
//                NSURL* url = [representation url];
//                _preShowPhoto.localPath=url.absoluteString;
//                _preShowImage = nil;
//                if (representation == nil) {
//                    CGImageRef thum = [_lastPhoto aspectRatioThumbnail];
//                    _preShowImage = [[UIImage alloc]initWithCGImage:thum];
//                }else
//                {
//                    _preShowImage =[[UIImage alloc]initWithCGImage:[[_lastPhoto defaultRepresentation] fullScreenImage]];
//                }
//                NSString *keyName = [[ZKPhotosCache sharedPhotoCache] getKeyName];
//                
//                _preShowPhoto.localPath=keyName;
//            }
//        }
//    } failureBlock:^(NSError *error) {
//        NSLog(@"Group not found!\n");
//    }];
    
}

-(void)removeImage
{
    _lastPhoto = nil;
    [_preShow removeFromSuperview];
}

-(void)showEmotions:(id)sender
{
    [_recordButton setImage:[UIImage imageNamed:@"record_normal"] forState:UIControlStateNormal];
    _recordButton.tag = DDVoiceInput;
    [self.chatInputView willBeginInput];
    if ([_currentInputContent length] > 0)
    {
        [self.chatInputView.textView setText:_currentInputContent];
    }
    
    if (self.emotions == nil) {
        self.emotions = [ZKEmotionsViewController new];
        [self.emotions.view setBackgroundColor:[UIColor whiteColor]];
        self.emotions.view.frame=DDCOMPONENT_BOTTOM;
        self.emotions.delegate = self;
        [self.view addSubview:self.emotions.view];
    }
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
        [self.chatInputView.textView resignFirstResponder];
        [self.emotions.view setFrame:DDEMOTION_FRAME];
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //表情面板本来就是显示的,这时需要隐藏所有底部界面
        [self.chatInputView.textView resignFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件，这时需要隐藏插件，显示表情
        [self.ddUtility.view setFrame:DDCOMPONENT_BOTTOM];
        [self.emotions.view setFrame:DDEMOTION_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
    }
    else
    {
        //这是什么都没有显示，需用动画显示表情
        _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
        [UIView animateWithDuration:0.25 animations:^{
            [self.emotions.view setFrame:DDEMOTION_FRAME];
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
    }
}
#pragma mark - KeyBoardNotification
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent | DDShowKeyboard;
    [UIView animateWithDuration:0.25 animations:^{
        [self.chatInputView setFrame:CGRectMake(0, keyboardRect.origin.y - DDINPUT_HEIGHT, self.view.size.width, DDINPUT_HEIGHT)];
    }];
    [self setValue:@(keyboardRect.origin.y - DDINPUT_HEIGHT) forKeyPath:@"_inputViewY"];
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    CGRect keyboardRect;
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    _bottomShowComponent = _bottomShowComponent & DDHideKeyboard;
    if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情
        [UIView animateWithDuration:0.25 animations:^{
            [self.chatInputView setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(self.chatInputView.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    else
    {
        [self p_hideBottomComponent];
    }
}
@end
