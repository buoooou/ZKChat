//
//  AppDelegate.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKLoginViewController.h"
#import "ZKConstant.h"
#import "NSDictionary+Safe.h"
#import "ZKSessionEntity.h"
#import "ZKChattingMainViewController.h"
#import "RuntimeStatus.h"
#import "ZKUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [RuntimeStatus instance];
    // 推送消息的注册方式
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // for iOS 8
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    }
    
    if( SYSTEM_VERSION >=8 ) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }
    
    // 移除webview cache
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    
    ZKLoginViewController * loginVC=[[ZKLoginViewController alloc]init];
    UINavigationController *navRoot =[[UINavigationController alloc] initWithRootViewController:loginVC];
    
    self.window.rootViewController = navRoot;
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    [self.window makeKeyAndVisible];
    
    UIImageView *welcome = [[UIImageView alloc]initWithFrame:self.window.bounds];
    
    [welcome setImage:[UIImage imageNamed:@"chatBg"]];
    
    //把背景图放在最上层
    
    [self.window addSubview:welcome];
    
    [self.window bringSubviewToFront:welcome];
    
    [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        
        welcome.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [welcome removeFromSuperview];
        
    }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //   if ([[SessionModule instance]getAllUnreadMessageCount] == 0) {
    //       [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //   }else{
    //     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[SessionModule instance]getAllUnreadMessageCount]];
    // }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"获取令牌失败:  %@",error_str);
}
// 处理推送消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    UIApplicationState state =application.applicationState;
    if ( state != UIApplicationStateBackground) {
        return;
    }
    NSString *jsonString = [userInfo safeObjectForKey:@"custom"];
    NSData* infoData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* info = [NSJSONSerialization JSONObjectWithData:infoData options:0 error:nil];
    NSInteger from_id =[[info safeObjectForKey:@"from_id"] integerValue];
    SessionType type = (SessionType)[[info safeObjectForKey:@"msg_type"] integerValue];
    NSInteger group_id =[[info safeObjectForKey:@"group_id"] integerValue];
    if (from_id) {
        NSInteger sessionId = type==1?from_id:group_id;
        ZKSessionEntity *session = [[ZKSessionEntity alloc] initWithSessionID:[ZKUtil changeOriginalToLocalID:(UInt32)sessionId SessionType:(int)type] type:type] ;
        [[ZKChattingMainViewController shareInstance] showChattingContentForSession:session];
    }
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ZKChat"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
