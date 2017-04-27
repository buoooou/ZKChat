//
//  ZKMessageViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/20.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKMessageViewController.h"
#import "ZKConstant.h"
#import "ZKRecentUserCell.h"
#import "ZKChattingMainViewController.h"
#import "ZKNormalCell.h"
#import "ZKChattingUtilityViewController.h"
#import "ZKDatabaseUtil.h"
#import "ZKMessageEntity.h"
#import "DDMessageModule.h"

@interface ZKMessageViewController ()
@property(nonatomic,strong)NSMutableDictionary *lastMsgs;
@property(nonatomic,strong)UISearchBar *searchBar;
//@property(nonatomic,strong)SearchContentViewController *searchContent;
@property(nonatomic,assign)NSInteger fixedCount;
@property(nonatomic,strong)UITableView* searchTableView;
@property(nonatomic,strong)UIView* searchPlaceholderView;
@property(nonatomic,assign)BOOL isMacOnline;
- (void)n_receiveStartLoginNotification:(NSNotification*)notification;
- (void)n_receiveLoginFailureNotification:(NSNotification*)notification;@end

@implementation ZKMessageViewController
- (id)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
+ (instancetype)shareInstance
{
    static ZKMessageViewController* g_recentUsersViewController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_recentUsersViewController = [ZKMessageViewController new];
    });
    return g_recentUsersViewController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"消息";

    [self.tableView registerClass:[ZKBaseCell class] forCellReuseIdentifier:@"ZKPCStatusCellIdentifier"];
    [self.tableView registerClass:[ZKRecentUserCell class] forCellReuseIdentifier:@"ZKRecentUserCellIdentifier"];
    
    self.dataSource=[NSMutableArray new];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:ZKBG];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 40)];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = ZKBG;
    self.searchBar.layer.borderWidth = 0.5;
    self.searchBar.layer.borderColor = RGB(204, 204, 204).CGColor;
    self.tableView.tableHeaderView = self.searchBar;
    
    self.lastMsgs = [NSMutableDictionary new];
    self.isMacOnline = 0;
    
    [self.dataSource addObjectsFromArray:[[SessionModule instance] getAllSessions]];
    [self sortItems];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[SessionModule instance] getRecentSession:^(NSUInteger count) {
            
            [self.data removeAllObjects];
            [self.items addObjectsFromArray:[[SessionModule instance] getAllSessions]];
            
            [self sortItems];
            
            //            NSUInteger unreadcount =  [[self.items valueForKeyPath:@"@sum.unReadMsgCount"] integerValue];
            NSUInteger unreadcount =  [[SessionModule instance]getAllUnreadMessageCount];
            
            [self setToolbarBadge:unreadcount];
            
        }];
    });
    
    
    [SessionModule instance].delegate=self;
    
    // 初始化searchTableView
    [self addSearchTableView];
}
-(void)addSearchTableView{
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    [self.view addSubview:self.searchTableView];
    [self.searchTableView setHidden:YES];
    [self.searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.searchTableView setBackgroundColor:TTBG];
    self.searchContent = [SearchContentViewController new];
    self.searchContent.viewController=self;
    self.searchTableView.delegate = self.searchContent.delegate;
    self.searchTableView.dataSource = self.searchContent.dataSource;
    
    __weak __typeof(self)weakSelf = self;
    self.searchContent.didScrollViewScrolled = ^(){
        [weakSelf.view endEditing:YES];
        [weakSelf enableControlsInView:weakSelf.searchBar];
    };
    
    self.searchPlaceholderView = [[UIView alloc]initWithFrame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    [self.view addSubview:self.searchPlaceholderView];
    [self.searchPlaceholderView setHidden:YES];
    [self.searchPlaceholderView setBackgroundColor:[UIColor whiteColor]];
    
    // 点击取消
    self.searchPlaceholderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endSearch)];
    [self.searchPlaceholderView addGestureRecognizer:tapGesture];
    
    // 添加其他元素
    UILabel *searchMore = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 20)];
    [self.searchPlaceholderView addSubview:searchMore];
    [searchMore setTextAlignment:NSTextAlignmentCenter];
    [searchMore setText:@"搜索更多内容"];
    [searchMore setFont:systemFont(20)];
    [searchMore setTextColor:RGB(129, 129, 131)];
    
    UILabel *searchMoreLine = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 95, 200, 0.5)];
    [self.searchPlaceholderView addSubview:searchMoreLine];
    [searchMoreLine setBackgroundColor:RGB(230, 230, 232)];
    
    UIView *searchMoreContent = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 110, 200, 50)];
    [self.searchPlaceholderView addSubview:searchMoreContent];
    
    UIImageView *searchUser = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [searchUser setImage:[UIImage imageNamed:@"search_user"]];
    [searchMoreContent addSubview:searchUser];
    
    UILabel *searchUserLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 25, 25)];
    [searchUserLabel setText:@"用户"];
    [searchUserLabel setTextColor:RGB(170, 170, 171)];
    [searchUserLabel setFont:systemFont(12)];
    [searchUserLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchUserLabel];
    
    UIImageView *searchGroup = [[UIImageView alloc]initWithFrame:CGRectMake(25+33, 0, 25, 25)];
    [searchGroup setImage:[UIImage imageNamed:@"search_group"]];
    [searchMoreContent addSubview:searchGroup];
    
    UILabel *searchGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(25+33, 35, 25, 25)];
    [searchGroupLabel setText:@"群组"];
    [searchGroupLabel setTextColor:RGB(170, 170, 171)];
    [searchGroupLabel setFont:systemFont(12)];
    [searchGroupLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchGroupLabel];
    
    UIImageView *searchDepartment = [[UIImageView alloc]initWithFrame:CGRectMake((25+33)*2, 0, 25, 25)];
    [searchDepartment setImage:[UIImage imageNamed:@"search_department"]];
    [searchMoreContent addSubview:searchDepartment];
    
    UIImageView *searchChat = [[UIImageView alloc]initWithFrame:CGRectMake((25+33)*3, 0, 25, 25)];
    [searchChat setImage:[UIImage imageNamed:@"search_chat"]];
    [searchMoreContent addSubview:searchChat];
    
    UILabel *searchChatLabel = [[UILabel alloc]initWithFrame:CGRectMake((25+33)*3, 35, 25, 25)];
    [searchChatLabel setText:@"聊天"];
    [searchChatLabel setTextColor:RGB(170, 170, 171)];
    [searchChatLabel setFont:systemFont(12)];
    [searchChatLabel setTextAlignment:NSTextAlignmentCenter];
    [searchMoreContent addSubview:searchChatLabel];
}
-(void)sortItems
{
    [self.dataSource removeAllObjects];
    
    [self.dataSource addObjectsFromArray:[[SessionModule instance] getAllSessions]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [self.dataSource sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [self.dataSource sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.title=APP_NAME;
    self.navigationController.navigationBarHidden =NO;
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.tableView.contentInset =UIEdgeInsetsMake(64, 0, 49, 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }else{
        return [self.dataSource count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if(indexPath.section == 0){
        //        if(self.isMacOnline){
        //            height = 45;
        //        }else{
        //            height = 0;
        //        }
        height = 0;//其他设备登录标示
    }else{
        height = 65;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString* cellIdentifier = @"ZKPCStatusCellIdentifier";
        //        ZKPCStatusCell* cell = (MTTPCStatusCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //        if (!cell)
        //        {
        //            cell = [[MTTPCStatusCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        //        }
        //        if(!self.isMacOnline){
        //            [cell setHidden:YES];
        //        }
        //pc设备登录提示
        ZKNormalCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.backgroundColor=RGB(200, 200, 209);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(80, 12, SCREEN_WIDTH, 20)];
        label.text=@"ZKChat已在Mac登录";
        label.textColor=ZKGRAY;
        label.font=systemFont(14);
        
        [cell addSubview:label];
        cell.imageView.image = [UIImage imageNamed:@"mac_logined"];
        [cell setHidden:YES];
        return cell;
    }else{
        static NSString* cellIdentifier = @"ZKRecentUserCellIdentifier";
        ZKRecentUserCell* cell = (ZKRecentUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[ZKRecentUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
                NSInteger row = [indexPath row];
        UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
        view.backgroundColor=RGB(229, 229, 229);
                ZKSessionEntity *session = self.dataSource[row];
                if(session.isFixedTop){
                    [cell setBackgroundColor:RGB(243, 243, 247)];
                }else{
                    [cell setBackgroundColor:[UIColor whiteColor]];
                }
        cell.selectedBackgroundView=view;
        [cell setShowSession:self.dataSource[row]];
        [self preLoadMessage:self.dataSource[row]];
        return cell;
    }
    
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //        NSInteger row = [indexPath row];
        //        MTTSessionEntity *session = self.items[row];
        [ZKChattingMainViewController shareInstance].title=@"张阔";
        //        [[ZKChattingMainViewController shareInstance] showChattingContentForSession:session];
        [self pushViewController:[ZKChattingMainViewController shareInstance] animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSUInteger row = [indexPath row];
    //    MTTSessionEntity *session = self.items[row];
    //    [[SessionModule instance] removeSessionByServer:session];
    //    [self.items removeObjectAtIndex:row];
    //    [self setToolbarBadge:[[SessionModule instance]getAllUnreadMessageCount]];
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)preLoadMessage:(ZKSessionEntity *)session
{
    [[ZKDatabaseUtil instance] getLastestMessageForSessionID:session.sessionID completion:^(ZKMessageEntity *message, NSError *error) {
        if (message) {
            if (message.msgID != session.lastMsgID ) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    [[ZKDatabaseUtil instance] insertMessages:array success:^{
                        
                    } failure:^(NSString *errorDescripe) {
                        
                    }];
                }];
            }
        }else{
            if (session.lastMsgID !=0) {
                [[DDMessageModule shareInstance] getMessageFromServer:session.lastMsgID currentSession:session count:20 Block:^(NSMutableArray *array, NSError *error) {
                    [[ZKDatabaseUtil instance] insertMessages:array success:^{
                        
                    } failure:^(NSString *errorDescripe) {
                        
                    }];
                }];
            }
        }
    }];
}

@end
