//
//  ZKTableViewController.h
//  ZKChat
//
//  Created by 张阔 on 2017/2/14.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKBaseViewController.h"

@interface ZKBaseTableViewController :ZKBaseViewController<UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating>
/**
 *显示数据表格
 */
@property (nonatomic,strong)UITableView *tableView;
/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
/**
 *数据源
 */
@property (nonatomic,strong)NSMutableArray *dataSource;
/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;
- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle;
@end
