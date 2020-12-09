//
//  ViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+vhall.h"
#import <VHLSS/VHLivePublisher.h>
#import <VHLSS/VHLivePlayer.h>
#import <VHLSS/VHVodPlayer.h>

#import "PublishViewController.h"
#import "WatchViewController.h"
#import "WatchVodViewController.h"
#import "VHPlayerSkinViewController.h"
#import "VHSettingViewController.h"


#define VHScreenHeight          ([UIScreen mainScreen].bounds.size.height)
#define VHScreenWidth           ([UIScreen mainScreen].bounds.size.width)
#define VH_SH                   ((VHScreenWidth<VHScreenHeight) ? VHScreenHeight : VHScreenWidth)
#define VH_SW                   ((VHScreenWidth<VHScreenHeight) ? VHScreenWidth  : VHScreenHeight)


@interface ViewController ()
{
    UITextField *_businessIDTextField;
    UITextField *_accessTokenTextField;
    UITextField *_recordIDTextField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSDKView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showInitSDKVC];
}

- (void)settingBtnClicked:(UIButton*)sender
{
    VHSettingViewController * settingVC = [[VHSettingViewController alloc] init];
    settingVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingVC animated:YES completion:nil];
}
//发直播
- (void)publishBtnClicked:(UIButton*)sender
{
    if(![self isCaptureDeviceOK])
        return;
    
    if(_businessIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }

    DEMO_Setting.publishRoomID = _businessIDTextField.text;
    DEMO_Setting.playerRoomID = _businessIDTextField.text;
    DEMO_Setting.accessToken =_accessTokenTextField.text;
    
    PublishViewController * rtmpLivedemoVC = [[PublishViewController alloc] init];
    rtmpLivedemoVC.videoResolution  = DEMO_Setting.videoResolution.intValue;
    rtmpLivedemoVC.roomId           = DEMO_Setting.publishRoomID;
    rtmpLivedemoVC.accessToken      = DEMO_Setting.accessToken;
    rtmpLivedemoVC.videoBitRate     = DEMO_Setting.videoBitRate;
    rtmpLivedemoVC.audioBitRate     = DEMO_Setting.audioBitRate;
    rtmpLivedemoVC.videoCaptureFPS  = DEMO_Setting.videoCaptureFPS;
    rtmpLivedemoVC.interfaceOrientation  = (sender.tag == 1)?UIInterfaceOrientationLandscapeRight :UIInterfaceOrientationPortrait;
    rtmpLivedemoVC.isOpenNoiseSuppresion = DEMO_Setting.isOpenNoiseSuppresion;
    rtmpLivedemoVC.beautifyFilterEnable  = DEMO_Setting.isBeautifyFilterEnable;
    rtmpLivedemoVC.volumeAmplificateSize = DEMO_Setting.volumeAmplificateSize;
    rtmpLivedemoVC.isOnlyAudio           = DEMO_Setting.isOnlyAudio;
    rtmpLivedemoVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:rtmpLivedemoVC animated:YES completion:nil];
}
//直播
- (void)playerBtnClicked:(UIButton*)sender
{
    if(_businessIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }

    DEMO_Setting.publishRoomID = _businessIDTextField.text;
    DEMO_Setting.playerRoomID = _businessIDTextField.text;
    DEMO_Setting.accessToken =_accessTokenTextField.text;
    
    WatchViewController * watchVC = [[WatchViewController alloc] init];
    watchVC.roomId      = DEMO_Setting.playerRoomID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    watchVC.bufferTime  = DEMO_Setting.bufferTime;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}
//点播
- (void)vodBtnClicked:(UIButton*)sender
{
    if(_recordIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }

    DEMO_Setting.recordID = _recordIDTextField.text;
    DEMO_Setting.accessToken =_accessTokenTextField.text;
    
    WatchVodViewController * watchVC = [[WatchVodViewController alloc] init];
    watchVC.recordID    = DEMO_Setting.recordID;
    watchVC.accessToken = DEMO_Setting.accessToken;
    watchVC.seekMode    = DEMO_Setting.seekMode;
    watchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:watchVC animated:YES completion:nil];
}
//点播皮肤
- (void)vodBtn1Clicked:(UIButton *)sender {
    if(_recordIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }
    
    DEMO_Setting.recordID = _recordIDTextField.text;
    DEMO_Setting.accessToken =_accessTokenTextField.text;
    
    VHPlayerSkinViewController * vc = [[VHPlayerSkinViewController alloc] initWithrecordId:DEMO_Setting.recordID accessToken:DEMO_Setting.accessToken];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}
//直播皮肤
- (void)liveSkinBtnClicked:(UIButton *)sender {
    if(_businessIDTextField.text.length == 0 || _accessTokenTextField.text.length == 0)
    {
        [self showMsg:@"参数不能为空" afterDelay:1.5];
        return;
    }

    DEMO_Setting.playerRoomID = _businessIDTextField.text;
    DEMO_Setting.accessToken =_accessTokenTextField.text;

    VHPlayerSkinViewController * vc = [[VHPlayerSkinViewController alloc] initWithLiveId:DEMO_Setting.playerRoomID accessToken:DEMO_Setting.accessToken];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)initSDKView
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, VHScreenWidth - 40, 20)];
    lable.text = @"请输入roomID lss_xxxx:";
    lable.textColor = [UIColor grayColor];
    [self.view addSubview:lable];
    
    UITextField *businessIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, lable.bottom, VHScreenWidth - 40, 30)];
    businessIDTextField.placeholder = @"请输入roomID lss_xxxx";
    businessIDTextField.text = DEMO_Setting.playerRoomID;
    businessIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    businessIDTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    businessIDTextField.delegate  = self;
    _businessIDTextField = businessIDTextField;
    [self.view addSubview:businessIDTextField];
    
    UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(20, businessIDTextField.bottom+10, businessIDTextField.width, 20)];
    lable1.text = @"请输入recordID:";
    lable1.textColor = [UIColor grayColor];
    [self.view addSubview:lable1];
    
    UITextField *recordIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(businessIDTextField.left, lable1.bottom, businessIDTextField.width, businessIDTextField.height)];
    recordIDTextField.placeholder = @"请输入recordID";
    recordIDTextField.text = DEMO_Setting.recordID;
    recordIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    recordIDTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    recordIDTextField.delegate  = self;
    _recordIDTextField = recordIDTextField;
    [self.view addSubview:recordIDTextField];
    
    UILabel* lable2 = [[UILabel alloc] initWithFrame:CGRectMake(20, recordIDTextField.bottom+10, businessIDTextField.width, 20)];
    lable2.text = @"请输入accessToken:";
    lable2.textColor = [UIColor grayColor];
    [self.view addSubview:lable2];
    
    UITextField *accessTokenTextField = [[UITextField alloc] initWithFrame:CGRectMake(businessIDTextField.left, lable2.bottom, VHScreenWidth - 40, businessIDTextField.height)];
    accessTokenTextField.placeholder = @"请输入accessToken";
    accessTokenTextField.text = DEMO_Setting.accessToken;
    accessTokenTextField.borderStyle = UITextBorderStyleRoundedRect;
    accessTokenTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    accessTokenTextField.delegate  = self;
    _accessTokenTextField = accessTokenTextField;
    [self.view addSubview:accessTokenTextField];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(accessTokenTextField.left, accessTokenTextField.bottom+10, 70, accessTokenTextField.height)];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn setTitle:@"竖屏直播" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(publishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:nextBtn];
    
    UIButton *nextBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(nextBtn.right+10 , nextBtn.top, nextBtn.width, accessTokenTextField.height)];
    nextBtn1.tag = 1;
    nextBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn1 setTitle:@"横屏直播" forState:UIControlStateNormal];
    [nextBtn1 addTarget:self action:@selector(publishBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:nextBtn1];
    
    UIButton *liveSkin = [[UIButton alloc] initWithFrame:CGRectMake(nextBtn1.right + 10, nextBtn1.top, nextBtn1.width, accessTokenTextField.height)];
    liveSkin.titleLabel.font = [UIFont systemFontOfSize:15];
    [liveSkin setTitle:@"直播皮肤" forState:UIControlStateNormal];
    [liveSkin addTarget:self action:@selector(liveSkinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    liveSkin.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:liveSkin];
    
//    UIButton *nextBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(accessTokenTextField.left, nextBtn.top, nextBtn.width, accessTokenTextField.height)];
//    nextBtn2.tag = 102;
//    nextBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
//    [nextBtn2 setTitle:@"录屏直播" forState:UIControlStateNormal];
//    [nextBtn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    nextBtn.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:nextBtn2];
    
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-70,nextBtn.top, 50, accessTokenTextField.height)];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:settingBtn];
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(accessTokenTextField.left, nextBtn.bottom+10, nextBtn.width, accessTokenTextField.height)];
    playBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [playBtn setTitle:@"观看直播" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:playBtn];
    

    UIButton *vodBtn = [[UIButton alloc] initWithFrame:CGRectMake(playBtn.right + 10, playBtn.top, playBtn.width, accessTokenTextField.height)];
    vodBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [vodBtn setTitle:@"观看点播" forState:UIControlStateNormal];
    [vodBtn addTarget:self action:@selector(vodBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    vodBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vodBtn];
    
    
    UIButton *vodBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(vodBtn.right + 10, vodBtn.top, vodBtn.width, accessTokenTextField.height)];
    vodBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [vodBtn1 setTitle:@"点播皮肤" forState:UIControlStateNormal];
    [vodBtn1 addTarget:self action:@selector(vodBtn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    vodBtn1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vodBtn1];

    
    UILabel * label= [[UILabel alloc] initWithFrame:CGRectMake(0, VHScreenHeight - 100, VHScreenWidth, 20)];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"微吼云 LSS SDK v%@",[VHLivePlayer getSDKVersion]];
    [self.view addSubview:label];
}

#pragma mark - 权限检查
//    iOS 判断应用是否有使用相机的权限
- (BOOL)isCaptureDeviceOK
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"相机权限受限,请在设置中启用";
        [self showMsg:errorStr afterDelay:2];
        return NO;
    }
    
    mediaType = AVMediaTypeAudio;//读取媒体类型
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"麦克风权限受限,请在设置中启用";
        [self showMsg:errorStr afterDelay:2];
        return NO;
    }
    
    return YES;
}



@end
