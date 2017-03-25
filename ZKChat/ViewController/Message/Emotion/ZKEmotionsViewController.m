//
//  ZKEmotionsViewController.m
//  ZKChat
//
//  Created by 张阔 on 2017/3/3.
//  Copyright © 2017年 张阔. All rights reserved.
//

#import "ZKEmotionsViewController.h"
#import "ZKConstant.h"
#import "EmotionsModule.h"
#import <Masonry.h>

#define  keyboardHeight 180
#define  facialViewWidth 300
#define facialViewHeight 170
#define  DD_EMOTION_MENU_HEIGHT             50
@interface ZKEmotionsViewController ()

@end

@implementation ZKEmotionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 216);

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
    
    self.emotions = [NSArray arrayWithArray:[EmotionsModule shareInstance].emotionUnicodeDic.allKeys];
    if (self.scrollView==nil) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.scrollView setBackgroundColor:[UIColor whiteColor]];
        for (int i=0; i<3; i++) {
            [self p_loadFacialViewWithRow:i CGSize:CGSizeMake((SCREEN_WIDTH - 10)/4, 90)];
        }
    }
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, keyboardHeight);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    [self.scrollView setBackgroundColor:RGB(244, 244, 246)];
    [self.view addSubview:self.scrollView];
    
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-70, self.view.frame.size.height-30 , 150, 30)];
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor=RGB(245, 62, 102);
    self.pageControl.numberOfPages = 3;
    [self.pageControl setBackgroundColor:RGB(244, 244, 246)];
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)changePage:(id)sender {
    NSInteger page = self.pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}

- (void)clickTheSendButton:(id)sender
{
    if (self.delegate)
    {
        [self.delegate emotionViewClickSendButton];
    }
}
- (void)p_loadFacialViewWithRow:(NSUInteger)page CGSize:(CGSize)size
{
    NSArray* emotions = [NSArray arrayWithArray:[EmotionsModule shareInstance].emotionUnicodeDic.allKeys];
    UIView* yayaview=[[UIView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*page, 15, SCREEN_WIDTH-30, facialViewHeight)];
    [yayaview setBackgroundColor:[UIColor clearColor]];
    
    for (int i=0; i< 2; i++) {
        for (int y=0; y< 4; y++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            
            if ((i * 4 + y + page * 8) >= [emotions count]) {
                break ;
            }else{
                //表情
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:27.0]];
                [button setTitle: [emotions objectAtIndex:i*4+y+(page*8)]forState:UIControlStateNormal];
                button.tag=i*4+y+(page*8);
                NSString *emotionStr = [[EmotionsModule shareInstance].emotionUnicodeDic objectForKey:emotions[i*4 + y + page*8]];
                UIImage* emotionImage = [UIImage imageNamed:emotionStr];
                [button setImage:emotionImage forState:UIControlStateNormal];
                [button addTarget:self action:@selector(p_selected:) forControlEvents:UIControlEventTouchUpInside];
                [yayaview addSubview:button];
            }
        }
    }
    [self.scrollView addSubview:yayaview];
}
-(void)p_selected:(UIButton*)button
{
    NSArray* emotions = [EmotionsModule shareInstance].emotions;
    NSString *str=[emotions objectAtIndex:button.tag];
    [self selectedFacialView:str];
}
-(void)selectedFacialView:(NSString*)str
{
//    if ([str isEqualToString:@"delete"]) {
//        [[ZKChattingMainViewController shareInstance] deleteEmojiFace];
//        return;
//    }
//    [[ZKChattingMainViewController shareInstance] insertEmojiFace:str];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.pageControl.currentPage = self.scrollView.contentOffset.x / SCREEN_WIDTH;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = page;
}


@end
