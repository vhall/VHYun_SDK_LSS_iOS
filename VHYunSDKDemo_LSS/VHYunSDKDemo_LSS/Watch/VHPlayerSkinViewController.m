//
//  VHPlayerSkinViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHPlayerSkinViewController.h"
#import <VHLSS/VHVodPlayer.h>
#import <VHLSS/VHLivePlayer.h>
#import "VHCustomPlayerSkinView.h"
#import "VHSkinCoverView.h"

@interface VHPlayerSkinViewController ()<UIGestureRecognizerDelegate,VHVodPlayerDelegate,VHLivePlayerDelegate>
{
    VHCustomPlayerSkinView *_skinView;
}
@property (nonatomic, strong) VHVodPlayer *vodPlayer;
@property (nonatomic, strong) VHLivePlayer *livePlayer;

@property (nonatomic) BOOL isLive;//是否是直播

/** 返回*/
@property (nonatomic, strong) UIButton *backBtn;

/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation VHPlayerSkinViewController

#pragma nark - creat

- (instancetype)initWithLiveId:(NSString *)liveId accessToken:(NSString *)token {
    if (self = [super init]) {
        
        [self.livePlayer startPlay:liveId accessToken:token];
        self.isLive = YES;
    }
    return self;
}
- (instancetype)initWithrecordId:(NSString *)recordId accessToken:(NSString *)token {
    if (self = [super init]) {
        
        [self.vodPlayer startPlay:recordId accessToken:token];
        self.isLive = NO;
    }
    return self;
}
- (VHVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[VHVodPlayer alloc] init];
        _vodPlayer.delegate = self;
    }
    return _vodPlayer;
}
- (VHLivePlayer *)livePlayer {
    if (!_livePlayer) {
//        _livePlayer = [[VHLivePlayer alloc] initWithFastPlayerInteractID:nil];    // 快直播
        _livePlayer = [[VHLivePlayer alloc] init];
        _livePlayer.delegate = self;
    }
    return _livePlayer;
}

- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        _singleTap.delegate                = self;
        _singleTap.numberOfTouchesRequired = 1; //手指数
        _singleTap.numberOfTapsRequired    = 1;
        [self.singleTap setDelaysTouchesBegan:YES];
    }
    return _singleTap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUi];
}

- (void)setUpUi
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    VHCustomPlayerSkinView *skinView = [[VHCustomPlayerSkinView alloc] initWithFrame:self.livePlayer.view.bounds];
    skinView.isLive = self.isLive;
    _skinView = skinView;

    if (self.isLive)
    {
        [self.view addSubview:self.livePlayer.view];
        [self.livePlayer setPlayerSkinView:skinView];
        //添加点击手势
        [self.livePlayer.view addGestureRecognizer:self.singleTap];
    }
    else
    {
        [self.view addSubview:self.vodPlayer.view];
        [self.vodPlayer setPlayerSkinView:skinView];
        //添加点击手势
        [self.vodPlayer.view addGestureRecognizer:self.singleTap];
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:backBtn aboveSubview:self.vodPlayer.view];
    self.backBtn = backBtn;
}



#pragma mark - layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}
- (void)setOrientationPortraitConstraint {
    if (self.isLive) {
        self.livePlayer.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*3/4);
    }
    else {
        self.vodPlayer.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*3/4);
    }
    self.backBtn.hidden = NO;
}
- (void)setOrientationLandscapeConstraint {
    if (self.isLive) {
        self.livePlayer.view.frame = self.view.bounds;
    }
    else {
        self.vodPlayer.view.frame = self.view.bounds;
    }

    self.backBtn.hidden = YES;
}

#pragma mark - 点击手势
#pragma mark - UIGestureRecognizerDelegate gesAction
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[VHSkinCoverView class]]) {
        return NO;
    }
    return YES;
}

- (void)singleTapAction:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (_skinView) {
            if (_skinView.hidden) {
                [[_skinView fadeShow] fadeOut:5];
            } else {
                [_skinView fadeOut:0.2];
            }
        }
    }
}

#pragma mark - 支持横屏设置
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight);
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - 其他
- (void)goBack:(UIButton *)btn {
    if (self.isLive) {
        [_livePlayer stopPlay];
        [_livePlayer destroyPlayer];
    } else {
        [_vodPlayer stopPlay];
        [_vodPlayer destroyPlayer];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - VHLivePlayerDelegate
- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error {
    [self showMsg:error.description afterDelay:2];
}


@end
