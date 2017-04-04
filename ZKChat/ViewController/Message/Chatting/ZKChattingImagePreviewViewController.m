//
//  ZKChattingImagePreviewViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/2/27.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKChattingImagePreviewViewController.h"
#import <SVWebViewController.h>
#import <MBProgressHUD.h>
#import <ZXingObjC.h>
#import "UIImageView+WebCache.h"

@interface ZKChattingImagePreviewViewController ()
@property(nonatomic,strong)MWPhotoBrowser *browser ;
@end

@implementation ZKChattingImagePreviewViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    UIViewController;
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"预览";
    self.browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.browser.displayActionButton = NO;
    self.browser.displayNavArrows = NO;
    [self.browser setHidesBottomBarWhenPushed:YES];
    self.browser.zoomPhotosToFill = YES;
    [self.browser setCurrentPhotoIndex:self.index];
    [self.view addSubview:self.browser.view];
    [self addChildViewController:self.browser];
    [self.navigationController.navigationBar setHidden:YES];
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.browser.view addGestureRecognizer:longPressGr];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        LCActionSheet *sheet =[[LCActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存图片",@"识别二维码",nil];
        sheet.tag = 1000;
        [sheet show];
    }
    
}
#pragma mark - LCActionSheetDelegate

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1001){
        if(buttonIndex == 0){
        }
        if(buttonIndex == 1){
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.QRCodeResult;
        }
        if(buttonIndex == 2){
            
            NSURL *url = [NSURL URLWithString:self.QRCodeResult];
            SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
            
            UINavigationController *nav = (UINavigationController*)[[[[UIApplication sharedApplication]delegate]window]rootViewController];
            
            [nav pushViewController:webViewController animated:YES];
            
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    }
    if(actionSheet.tag == 1000){
        if(buttonIndex == 0){
            [self saveImage];
        }
        if(buttonIndex == 1){
            [self decodeQRImage];
            if (self.QRCodeResult) {
                NSURL *url = [NSURL URLWithString:self.QRCodeResult];
                NSArray *btns;
                if(url){
                    btns = @[self.QRCodeResult,@"复制内容",@"打开网址"];
                }else{
                    btns = @[self.QRCodeResult,@"复制内容"];
                }
                LCActionSheet *sheet =[[LCActionSheet alloc] initWithTitle:@"识别结果为:" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btns,nil];
                sheet.tag = 1001;
                [sheet show];
            } else {
                LCActionSheet *sheet =[[LCActionSheet alloc] initWithTitle:@"然而并不能识别" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil,nil];
                [sheet show];
            }
        }
    }
}
-(void)decodeQRImage
{
    MWPhoto *curImage = [self.photos objectAtIndex:self.browser.currentIndex];
//    ZXImage *img = [[ZXImage alloc]initWithURL:curImage.photoURL];
    
//    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithZXImage:img];
//    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
//    
//    NSError *error = nil;
//    
//    ZXDecodeHints *hints = [ZXDecodeHints hints];
//    
//    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
//    ZXResult *result = [reader decode:bitmap
//                                hints:hints
//                                error:&error];
//    self.QRCodeResult = result.text;
}
-(void)saveImage
{
    MWPhoto *curImage = [self.photos objectAtIndex:self.browser.currentIndex];
    UIImageView *imageview = [UIImageView new];
//    [imageview sd_setImageWithURL:curImage.photoURL];
    UIImageWriteToSavedPhotosAlbum(imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    if(!error){
        hud.labelText = @"保存成功";
    }else{
        hud.labelText = @"保存失败";
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return [self.photos count];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}
@end
