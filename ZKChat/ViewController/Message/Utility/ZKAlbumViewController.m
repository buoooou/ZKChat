//
//  ZKAlbumViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/21.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKAlbumViewController.h"
#import "ZKConstant.h"
#import "ZKAlbumDetailsViewController.h"
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
    
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self.dataSource addObject:assetCollection];
    }
    
    [self.tableView reloadData];
    
    [self.tableView registerClass:[ZKAlbumCell class] forCellReuseIdentifier:@"DDAlbumsCellIdentifier"];
    
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
    PHAssetCollection* assetCollection=[self.dataSource objectAtIndex:indexPath.row];
    NSString * name = assetCollection.localizedTitle;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@  ( %ld )",name,(long)[assets count]];
    PHAsset *asset=[assets lastObject];
    // 只会返回1张图片
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode=PHImageRequestOptionsResizeModeNone;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.avatar.image =result;
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZKAlbumDetailsViewController *details = [ZKAlbumDetailsViewController new];
    details.assetsCollection = [self.dataSource objectAtIndex:indexPath.row];
    [self pushViewController:details animated:YES];
    
}


@end
