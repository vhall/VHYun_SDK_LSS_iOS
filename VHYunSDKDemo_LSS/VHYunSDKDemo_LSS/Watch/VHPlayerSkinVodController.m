//
//  VHPlayerSkinVodController.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHPlayerSkinVodController.h"
#import <VHLSS/VHVodPlayer.h>
#import <VHLSS/VHLivePlayer.h>
#import "VHCustomPlayerSkinView.h"

@interface VHPlayerSkinVodController ()

@property (nonatomic, strong) VHVodPlayer *vodPlayer;
@property (nonatomic, strong) VHLivePlayer *livePlayer;

@property (nonatomic) BOOL isLive;

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation VHPlayerSkinVodController

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
    }
    return _vodPlayer;
}
- (VHLivePlayer *)livePlayer {
    if (!_livePlayer) {
        _livePlayer = [[VHLivePlayer alloc] init];
    }
    return _livePlayer;
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

    if (self.isLive) {
        [self.view addSubview:self.livePlayer.view];
        [self.livePlayer setPlayerSkinView:skinView];
    }
    else {
        [self.view addSubview:self.vodPlayer.view];
        [self.vodPlayer setPlayerSkinView:skinView];
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:backBtn aboveSubview:self.vodPlayer.view];
    self.backBtn = backBtn;
}

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

- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
