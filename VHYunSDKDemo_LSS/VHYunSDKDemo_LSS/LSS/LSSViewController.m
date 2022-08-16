//
//  LSSViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/3/9.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "LSSViewController.h"
#import <VHLSS/VHLivePublisher.h>
#import <VHLSS/VHVodPlayer.h>
#import "PublishViewController.h"
#import "WatchViewController.h"
#import "WatchVodViewController.h"
#import "WatchTimeshiftViewController.h"
#import "VHPlayerSkinViewController.h"
#import "VHSettingViewController.h"
#import "SampleScreenViewController.h"
#import "FeatCell.h"

@interface LSSViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *roomid_textfield;
@property (weak, nonatomic) IBOutlet UITextField *interactid_textfield;
@property (weak, nonatomic) IBOutlet UITextField *recordid_textfield;
@property (weak, nonatomic) IBOutlet UITextField *accesstoken_textfield;
@property (weak, nonatomic) IBOutlet UICollectionView *featCollectionView;
@property (nonatomic) NSArray *featdatas;
@property (nonatomic) BOOL isHorizontal;  // 横屏直播
@end

@implementation LSSViewController

- (NSArray *)featdatas {
	if(!_featdatas) {
		_featdatas = @[
            @{@"title":@"直播", @"items":@[
                @{@"title":@"直播-竖屏", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLive))},
                @{@"title":@"直播-竖屏\n老美颜", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLiveOB))},
                @{@"title":@"直播-竖屏\n三方美颜", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLiveNB))},
                @{@"title":@"直播-横屏", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLiveAtHorizontal))},
                @{@"title":@"直播-横屏\n三方美颜", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLiveNBAtHorizontal))},
                @{@"title":@"直播皮肤", @"bgcolor":[UIColor lightGrayColor], @"method":NSStringFromSelector(@selector(onClickPublishLiveWithSkin))}
            ]},
            @{@"title":@"播放", @"items":@[
                @{@"title":@"观看直播", @"bgcolor":[UIColor grayColor], @"method":NSStringFromSelector(@selector(onClickPlayerLive))},
                @{@"title":@"观看点播", @"bgcolor":[UIColor grayColor], @"method":NSStringFromSelector(@selector(onClickPlayerVod))},
                @{@"title":@"观看时移", @"bgcolor":[UIColor grayColor], @"method":NSStringFromSelector(@selector(onClickPlayerTimeshift))},
                @{@"title":@"点播皮肤", @"bgcolor":[UIColor grayColor], @"method":NSStringFromSelector(@selector(onClickPlayerVodSkin))},
                @{@"title":@"录屏直播", @"bgcolor":[UIColor grayColor], @"method":NSStringFromSelector(@selector(onClickSharedScreen))},
                @{@"title":@"快直播", @"bgcolor":[UIColor brownColor], @"method":NSStringFromSelector(@selector(onClickPlayerLiveFast))},
            ]},
            @{@"title":@"其他", @"items":@[
                @{@"title":@"设置", @"bgcolor":[UIColor blueColor], @"method":NSStringFromSelector(@selector(onClickSetting))}
            ]}
		];
	}
	return _featdatas;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.featCollectionView.delegate = self;
	self.featCollectionView.dataSource = self;
	[self.featCollectionView registerNib:[UINib nibWithNibName:@"FeatCell" bundle:nil] forCellWithReuseIdentifier:@"FeatCell"];
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    VHSystemInstance.playerRoomID = VHSystemInstance.publishRoomID;
	self.roomid_textfield.text = VHSystemInstance.publishRoomID;
	self.interactid_textfield.text = VHSystemInstance.ilssRoomID;
	self.recordid_textfield.text = VHSystemInstance.recordID;
	self.accesstoken_textfield.text = @"vhall";
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self showInitSDKVC];
}

#pragma mark- Publish Event

/// 竖屏直播
- (void)onClickPublishLive {
    [self saveInputValues];
    if(![self isCaptureDeviceOK]) {
        return;
    }
    VHPublishConfig *config = [self setupValueForPublishConfig];
    config.beautifyType = VHBeautifyTypeNone;
    PublishViewController *lssPublishVC = [[PublishViewController alloc] initWithRoomID:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken publishConfig:config];
    [self presentViewController:lssPublishVC animated:YES completion:nil];
}

/// 竖屏直播+新三方美颜
- (void)onClickPublishLiveNB {
    if(![self isCaptureDeviceOK]) {
        return;
    }
    VHPublishConfig *config = [self setupValueForPublishConfig];
    config.beautifyType = VHBeautifyTypeAdvanced;
    PublishViewController *lssPublishVC = [[PublishViewController alloc] initWithRoomID:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken                                                            publishConfig:config];
    [self presentViewController:lssPublishVC animated:YES completion:nil];
}

/// 竖屏直播+原有美颜
- (void)onClickPublishLiveOB {
    if(![self isCaptureDeviceOK]) {
        return;
    }
    VHPublishConfig *config = [self setupValueForPublishConfig];
    config.beautifyType = VHBeautifyTypeSimple;
    PublishViewController *lssPublishVC = [[PublishViewController alloc] initWithRoomID:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken publishConfig:config];
    [self presentViewController:lssPublishVC animated:YES completion:nil];
}

/// 横屏直播
- (void)onClickPublishLiveAtHorizontal {
    if(![self isCaptureDeviceOK]) {
        return;
    }
    VHPublishConfig *config = [self setupValueForPublishConfig];
    config.beautifyType = VHBeautifyTypeNone;
    config.orientation = AVCaptureVideoOrientationLandscapeRight;
    PublishViewController *lssPublishVC = [[PublishViewController alloc] initWithRoomID:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken publishConfig:config];
    [self presentViewController:lssPublishVC animated:YES completion:nil];
}

/// 横屏直播+新三方美颜
- (void)onClickPublishLiveNBAtHorizontal {
    if(![self isCaptureDeviceOK]) {
        return;
    }
    VHPublishConfig *config = [self setupValueForPublishConfig];
    config.beautifyType = VHBeautifyTypeAdvanced;
    config.orientation = AVCaptureVideoOrientationLandscapeRight;
    PublishViewController *lssPublishVC = [[PublishViewController alloc] initWithRoomID:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken publishConfig:config];
    [self presentViewController:lssPublishVC animated:YES completion:nil];
}

/// 直播皮肤
- (void)onClickPublishLiveWithSkin {
    VHPlayerSkinViewController * vc = [[VHPlayerSkinViewController alloc] initWithLiveId:VHSystemInstance.publishRoomID accessToken:VHSystemInstance.accessToken];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark- Player Event
/// 播放快直播
- (void)onClickPlayerLiveFast {
#if __has_include(<VHRTC/VHRenderView.h>)
    WatchViewController * watchVC = [[WatchViewController alloc] initWithRoomID:VHSystemInstance.playerRoomID interactID:VHSystemInstance.ilssRoomID accessToken:VHSystemInstance.accessToken BufferTime:VHSystemInstance.bufferTime];
    [self presentViewController:watchVC animated:YES completion:nil];
#else
    showToastMsg(@"未引入 VHRTC.framework ，所以无法使用快直播");
#endif
}

/// 播放直播
- (void)onClickPlayerLive {
    WatchViewController * watchVC = [[WatchViewController alloc] initWithRoomID:VHSystemInstance.playerRoomID accessToken:VHSystemInstance.accessToken BufferTime:VHSystemInstance.bufferTime];
    [self presentViewController:watchVC animated:YES completion:nil];
}

/// 播放回放
- (void)onClickPlayerVod {
    WatchVodViewController * watchVC = [[WatchVodViewController alloc] initWithRecordID:VHSystemInstance.recordID accessToken:VHSystemInstance.accessToken seekMode:VHSystemInstance.seekMode ? VHVodPlayerSeeekModelPlayed : VHVodPlayerSeeekModelDefault];
    [self presentViewController:watchVC animated:YES completion:nil];
}

/// 播放直播时移
- (void)onClickPlayerTimeshift {
    WatchTimeshiftViewController * watchVC = [[WatchTimeshiftViewController alloc] init];
    watchVC.roomId = VHSystemInstance.playerRoomID;
    watchVC.accessToken = VHSystemInstance.accessToken;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}

/// 播放器皮肤
- (void)onClickPlayerVodSkin {
    VHPlayerSkinViewController * vc = [[VHPlayerSkinViewController alloc] initWithrecordId:VHSystemInstance.recordID accessToken:VHSystemInstance.accessToken];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark- Other Event

/// 设置
- (void)onClickSetting {
    VHSettingViewController * settingVC = [[VHSettingViewController alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingVC animated:YES completion:nil];
}

/// 录屏直播
- (void)onClickSharedScreen {
    if(![self isCaptureDeviceOK]) {
        return;
    }
    SampleScreenViewController * rtmpLivedemoVC = [[SampleScreenViewController alloc] init];
    rtmpLivedemoVC.roomId           = VHSystemInstance.publishRoomID;
    rtmpLivedemoVC.accessToken      = VHSystemInstance.accessToken;
    rtmpLivedemoVC.videoBitRate     = 1500;
    rtmpLivedemoVC.videoCaptureFPS  = VHSystemInstance.videoCaptureFPS;
    rtmpLivedemoVC.extensionBundleID= @"com.vhallyun.lss.ScreenLive";
    rtmpLivedemoVC.interfaceOrientation  = UIInterfaceOrientationPortrait;
    rtmpLivedemoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:rtmpLivedemoVC animated:YES completion:nil];

}



#pragma mark- UI Level
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.featdatas.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSArray *)self.featdatas[section][@"items"]).count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	FeatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeatCell" forIndexPath:indexPath];
	NSDictionary *featDict = self.featdatas[indexPath.section][@"items"][indexPath.row];
	cell.titleLabel.text = featDict[@"title"];
	cell.normalColor = featDict[@"bgcolor"];
	cell.highlightedColor = [UIColor redColor];
	return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self saveInputValues];
	NSDictionary *featDict = self.featdatas[indexPath.section][@"items"][indexPath.row];
	self.isHorizontal = [featDict[@"title"] hasPrefix:@"横"];
	SEL selector = NSSelectorFromString(featDict[@"method"]);
	[self performSelector:selector];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake((collectionView.bounds.size.width/4)-10, 45);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 10;
}

#pragma mark- 权限检查
- (BOOL)isCaptureDeviceOK {
	NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
	if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
		NSString *errorStr = @"相机权限受限,请在设置中启用";
		[self showMsg:errorStr afterDelay:2];
		return NO;
	}

	mediaType = AVMediaTypeAudio;//读取媒体类型
	authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
	if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
		NSString *errorStr = @"麦克风权限受限,请在设置中启用";
		[self showMsg:errorStr afterDelay:2];
		return NO;
	}

	return YES;
}
- (VHPublishConfig *)setupValueForPublishConfig {
    VHPublishConfig *config = [VHPublishConfig configWithType:VHPublishConfigTypeDefault];
    config.videoBitRate = VHSystemInstance.videoBitRate;
    config.audioBitRate = VHSystemInstance.audioBitRate;
    config.videoCaptureFPS = VHSystemInstance.videoCaptureFPS;
    config.sampleRate = 32000;
    config.publishConnectTimes = 3;
    config.beautifyType = VHBeautifyTypeNone;
    config.captureDevicePosition = AVCaptureDevicePositionFront;
    config.orientation = AVCaptureVideoOrientationPortrait;
    config.isOpenNoiseSuppresion = YES;
    config.volumeAmplificateSize = 0;
    config.videoResolution = VHHDVideoResolution;
    config.pushType = VHStreamTypeVideoAndAudio;
    config.isPrintLog = YES;
    return config;
}
- (void)saveInputValues {
    VHSystemInstance.publishRoomID = self.roomid_textfield.text;
    VHSystemInstance.playerRoomID = self.roomid_textfield.text;
    VHSystemInstance.accessToken = self.accesstoken_textfield.text;
    VHSystemInstance.ilssRoomID = self.interactid_textfield.text;
}
@end
