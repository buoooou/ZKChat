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
#import "SessionModule.h"

@interface ZKMessageViewController ()
@property(nonatomic,strong)NSMutableDictionary *lastMsgs;
@property(nonatomic,strong)UISearchBar *searchBar;
//@property(nonatomic,strong)SearchContentViewController *searchContent;
@property(nonatomic,assign)NSInteger fixedCount;
//@property(nonatomic,strong)UITableView* searchTableView;
@property(nonatomic,strong)UIView* searchPlaceholderView;
@property(nonatomic,assign)BOOL isMacOnline;
- (void)n_receiveStartLoginNotification:(NSNotification*)notification;
- (void)n_receiveLoginFailureNotification:(NSNotification*)notification;
@end

@implementation ZKMessageViewController
- (id)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(n_receiveLoginFailureNotification:)
                                                     name:DDNotificationUserLoginFailure
                                                   object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(n_receiveLoginNotification:)
                                                 name:DDNotificationUserLoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:@"RefreshRecentData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(n_receiveReLoginSuccessNotification)
                                                 name:@"ReloginSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:ZKNotificationSessionShieldAndFixed
                                               object:nil];
    
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
            
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[[SessionModule instance] getAllSessions]];
            
            [self sortItems];
            NSUInteger unreadcount =  [[SessionModule instance] getAllUnreadMessageCount];
            
            [self setToolbarBadge:unreadcount];
            
        }];
    });
    
    
    [SessionModule instance].delegate=self;
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
-(void)setToolbarBadge:(NSUInteger)count
{
    
    if (count !=0) {
        if (count > 99)
        {
            [self.tabBarItem setBadgeValue:@"99+"];
        }
        else
        {
            [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
        }
    }else
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [self.tabBarItem setBadgeValue:nil];
    }
}
-(void)refreshData
{
    [self setToolbarBadge:0];
    [self sortItems];
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
    NSUInteger count = [[SessionModule instance]getAllUnreadMessageCount];
    [self setToolbarBadge:count];
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [ZKChattingMainViewController shareInstance].module.ZKSessionEntity=nil;
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
-(void)sessionUpdate:(ZKSessionEntity *)session Action:(SessionAction)action
{
    if (![self.dataSource containsObject:session]) {
        [self.dataSource insertObject:session atIndex:0];
    }
    [self sortItems];
    [self.tableView reloadData];
    NSUInteger count = [[SessionModule instance] getAllUnreadMessageCount];
    [self setToolbarBadge:count];
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                NSInteger row = [indexPath row];
        ZKSessionEntity *session = self.dataSource[row];
        [ZKChattingMainViewController shareInstance].title=session.name;
        [[ZKChattingMainViewController shareInstance] showChattingContentForSession:session];
        [self pushViewController:[ZKChattingMainViewController shareInstance] animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSUInteger row = [indexPath row];
        ZKSessionEntity *session = self.dataSource[row];
        [[SessionModule instance] removeSessionByServer:session];
        [self.dataSource removeObjectAtIndex:row];
        [self setToolbarBadge:[[SessionModule instance]getAllUnreadMessageCount]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
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
#pragma mark -  SNotification

- (void)n_receiveLoginFailureNotification:(NSNotification*)notification
{
    self.title = @"未连接";
}

- (void)n_receiveStartLoginNotification:(NSNotification*)notification
{
    self.title = APP_NAME;
}

- (void)n_receiveLoginNotification:(NSNotification*)notification
{
    self.title = APP_NAME;
}

-(void)n_receiveReLoginSuccessNotification
{
    self.title = APP_NAME;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SessionModule instance] getRecentSession:^(NSUInteger count) {
            
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[[SessionModule instance] getAllSessions]];
            [self sortItems];
            [self setToolbarBadge:count];
            
        }];
    });
}


@end
