//
//  ZKAlbumViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/21.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKAlbumViewController.h"
#import "ZKConstant.h"
#import "ZKAlbumDetailsViewControll.h"
#import "ZKAlbumCell.h"

@interface ZKAlbumViewController ()

@end

@implementation ZKAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource = [NSMutableArray new];
    self.assetsLibrary =  [[ALAssetsLibrary alloc] init];

    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *,BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        if (assetsGroup.numberOfAssets > 0)
        {
            [self.dataSource addObject:assetsGroup];
        }
        if (stop) {
            [self.tableView reloadData];
        }
        
    };
    //查找相册失败block
    void(^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    [self.tableView registerClass:[ZKAlbumCell class] forCellReuseIdentifier:@"DDAlbumsCellIdentifier"];
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"DDAlbumsCellIdentifier";
    ZKAlbumCell * cell = (ZKAlbumCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell =[[ZKAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    NSString * name = [[self.dataSource objectAtIndex:indexPath.row]
                       valueForProperty:ALAssetsGroupPropertyName];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  ( %ld )",name,(long)[[self.dataSource objectAtIndex:indexPath.row] numberOfAssets]];

    cell.avatar.image =[UIImage imageWithCGImage:[[self.dataSource objectAtIndex:indexPath.row] posterImage]] ;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKAlbumDetailsViewControll *details = [ZKAlbumDetailsViewControll new];
    details.assetsGroup = [self.dataSource objectAtIndex:indexPath.row];
    [self pushViewController:details animated:YES];
    
}


@end
