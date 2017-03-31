//
//  ZKChattingUtilityViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKChattingUtilityViewController.h"
#import <Masonry.h>
#import "ZKConstant.h"
#import "ZKChattingMainViewController.h"
#import "ZKAlbumViewController.h"
#import <Photos/Photos.h> 

@interface ZKChattingUtilityViewController ()
@property(nonatomic,strong)NSArray *itemsArray;
@property(nonatomic,strong)UIView *rightView;
@end

@implementation ZKChattingUtilityViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZK_WEAKSELF(ws);
    self.view.backgroundColor=RGB(244, 244, 246);
    UIView *topLine = [UIView new];
    [topLine setBackgroundColor:RGB(188, 188, 188)];
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(-0.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    
    UIView *leftView = [UIView new];
    [self.view addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.height.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.width.equalTo(ws.view).multipliedBy(0.25);
    }];
    
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:takePhotoBtn];
    [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"chat_take_photo"] forState:UIControlStateNormal];
    [takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [takePhotoBtn setClipsToBounds:YES];
    [takePhotoBtn.layer setCornerRadius:15];
    [takePhotoBtn.layer setBorderWidth:0.5];
    takePhotoBtn.backgroundColor=[UIColor whiteColor];
    [takePhotoBtn.layer setBorderColor:RGB(174, 177, 181).CGColor];
    
    [takePhotoBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *takePhotoLabel = [UILabel new];
    [takePhotoLabel setText:@"拍照"];
    [takePhotoLabel setTextAlignment:NSTextAlignmentCenter];
    [takePhotoLabel setFont:systemFont(13)];
    [takePhotoLabel setTextColor:RGB(174, 177, 181)];
    [self.view addSubview:takePhotoLabel];
    [takePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.mas_equalTo(takePhotoBtn.mas_bottom).offset(15);
        make.width.equalTo(leftView);
        make.height.mas_equalTo(13);
    }];
    
    UIView *middleView = [UIView new];
    [self.view addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.height.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.width.equalTo(ws.view).multipliedBy(0.25);
    }];
    
    UIButton *choosePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:choosePhotoBtn];
    [choosePhotoBtn setBackgroundImage:[UIImage imageNamed:@"chat_pick_photo"] forState:UIControlStateNormal];
    [choosePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [choosePhotoBtn setClipsToBounds:YES];
    [choosePhotoBtn.layer setCornerRadius:15];
    [choosePhotoBtn.layer setBorderWidth:0.5];
    [choosePhotoBtn.layer setBorderColor:RGB(174, 177, 181).CGColor];
    choosePhotoBtn.backgroundColor=[UIColor whiteColor];
    [choosePhotoBtn addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *choosePhotoLabel = [UILabel new];
    [choosePhotoLabel setText:@"相册"];
    [choosePhotoLabel setTextAlignment:NSTextAlignmentCenter];
    [choosePhotoLabel setFont:systemFont(13)];
    [choosePhotoLabel setTextColor:RGB(174, 177, 181)];
    [self.view addSubview:choosePhotoLabel];
    [choosePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.top.mas_equalTo(choosePhotoBtn.mas_bottom).offset(15);
        make.width.equalTo(middleView);
        make.height.mas_equalTo(13);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)choosePicture:(id)sender
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
//        }
    }
    if(status==PHAuthorizationStatusAuthorized){
        [self pushViewController:[ZKAlbumViewController new] animated:YES];
    }

}
-(void)takePicture:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if (self.imagePicker) {
            [[ZKChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:NO completion:nil];
        }else{
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[ZKChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:NO completion:nil];
        }
        
    });
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker=nil;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){

        __block UIImage *theImage = nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        UIImage *image = [self scaleImage:theImage toScale:0.3];
        NSData *imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        UIImage * m_selectImage = [UIImage imageWithData:imageData];
        __block ZKPhotoEnity *photo = [ZKPhotoEnity new];
        NSString *keyName = [[ZKPhotosCache sharedPhotoCache] getKeyName];
        photo.localPath=keyName;
        [picker dismissViewControllerAnimated:NO completion:nil];
        self.imagePicker=nil;
       // [[ZKChattingMainViewController shareInstance] sendImageMessage:photo Image:m_selectImage];
    
}

#pragma mark 等比縮放image
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
