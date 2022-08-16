//
//  LaunchLiveViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "PublishViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <VHLSS/VHLivePublisher.h>
#import <VHCore/VHLiveBase.h>

#import <VHBeautifyKit/VHBeautifyKit.h>
#import <VHBFURender/VHBFURender.h>

#import "OptionsPresentViewController.h"
#import "OptionRowCell.h"
#import <GLExtensions/UIViewController+GLExtension.h>

#define MakeColorRGBA(hex,a) ([UIColor colorWithRed:((hex>>16)&0xff)/255.0 green:((hex>>8)&0xff)/255.0 blue:(hex&0xff)/255.0 alpha:a])

@interface PublishViewController ()<VHLivePublisherDelegate>
{
	dispatch_source_t _timer;
	CGFloat _curBeautify;
	CGFloat _curBrightness;
	CGFloat _curSaturation;
}
@property (nonatomic) NSString *roomID;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) VHPublishConfig *config;
@property (assign, nonatomic) long liveTime;
@property (strong, nonatomic) VHLivePublisher *publisher;
@property (weak, nonatomic) IBOutlet UIView *perView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UILabel *bitRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *mirrorSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *noiseSwitch;
@property (weak, nonatomic) IBOutlet UIButton *videoStartAndStopBtn;
@property (weak, nonatomic) IBOutlet UISwitch *flashSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *beautifySwitch;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UIView *exposureControlView;
@property (weak, nonatomic) IBOutlet UISlider *exposureSlider;

@property (strong, nonatomic) UIView * focusView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (weak, nonatomic) IBOutlet UILabel *curBeautifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *curBrightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *curSaturationLabel;

@property (nonatomic) VHBeautifyKit *beautifyKit;
@property (nonatomic) NSArray<OptionItem *> *beautifyOptions;
@property (weak, nonatomic) IBOutlet UIButton *beautifyOptionButton;
@end

@implementation PublishViewController

#pragma mark - Lifecycle

- (instancetype)initWithRoomID:(NSString *)roomID accessToken:(NSString *)accesstoken publishConfig:(VHPublishConfig *)config {
	if((self = [super init])) {
		self.roomID = roomID;
		self.accessToken = accesstoken;
		self.config = config;
		self.modalPresentationStyle = UIModalPresentationFullScreen;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	[self setupDefaultValue];
	[self registerNotifications];
    if(self.config.beautifyType == VHBeautifyTypeAdvanced) {
        [VHLiveBase prepareBeautifyWithAccessToken:self.accessToken completeBlock:^(NSError *error) {
            [self initCameraEngine];
        }];
    }else{
        [self initCameraEngine];
    }
}

- (void)setupDefaultValue {
	self.mirrorSwitch.on = NO;
	self.noiseSwitch.on = NO;
	self.beautifySwitch.on = NO;
	self.flashSwitch.on = NO;
}

- (UIView *)focusView {
	if(!_focusView) {
		_focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
		_focusView.layer.borderWidth = 1.0;
		_focusView.layer.borderColor =[UIColor greenColor].CGColor;
		_focusView.backgroundColor = [UIColor clearColor];
		_focusView.hidden = YES;
		[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)]]; // 点击对焦
	}
	return _focusView;
}
- (void)dealloc {
	[VHBeautifyKit destroy];
	if (_publisher) {
		_publisher = nil;
	}

	//允许iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
//    VHLog(@"%@ dealloc",[[self class]description]);
}

- (void)LaunchLiveWillResignActive {
	[_publisher pause];
	[_publisher stopCapture];
}
- (void)LaunchLiveDidBecomeActive {
	[self performSelector:@selector(resume) withObject:nil afterDelay:1];
}
- (void)resume {
	[_publisher startCapture];
	[_publisher resume];
}
- (IBAction)closeBtnClick:(id)sender {
	if (_publisher.isPublishing) {
		[_publisher stopCapture];
	}
	[_publisher destoryObject];
	self.publisher = nil;

	[self dismissViewControllerAnimated:YES completion:^{
	 }];
	[self.navigationController popViewControllerAnimated:NO];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    switch (self.config.orientation) {
        case AVCaptureVideoOrientationPortrait:
            return UIInterfaceOrientationPortrait;
        case AVCaptureVideoOrientationLandscapeLeft:
            return UIInterfaceOrientationLandscapeLeft;
        case AVCaptureVideoOrientationLandscapeRight:
            return UIInterfaceOrientationLandscapeRight;
        default:
            return UIInterfaceOrientationPortraitUpsideDown;
    }
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    switch (self.config.orientation) {
        case AVCaptureVideoOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
        case AVCaptureVideoOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
        case AVCaptureVideoOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
        default:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

#pragma mark - Lifecycle(Private)
- (void)registerNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveWillResignActive)name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LaunchLiveDidBecomeActive)name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidLayoutSubviews {
	self.publisher.preView.frame = _perView.bounds;
}

#pragma mark - Camera
- (void)initCameraEngine {

	_curBeautify   = 4.0;
	_curBrightness = 1.05;
	_curSaturation = 1.1;

	switch (self.config.beautifyType) {
    // 三方美颜
        case VHBeautifyTypeAdvanced: {
            // 注意:viewDidLoad 中的前置鉴权
            [VHLiveBase prepareBeautifyWithAccessToken:self.accessToken completeBlock:^(NSError *error) {
                self.beautifyKit = [VHBeautifyKit beautifyManagerWithModuleClass:[VHBFURender class]];
                self.publisher = [[VHLivePublisher alloc] initWithConfig:self.config AndvancedBeautify:[self.beautifyKit currentModule] HandleError:^(NSError *error) {
                                          if(error) {
                                  showToastMsg([NSString stringWithFormat:@"⚠️美颜信息:%@", error]);
                                  self.beautifyOptionButton.enabled = NO;
                              }
                                          else{
                                  self.beautifyOptionButton.enabled = YES;
                              }
                          }];
                [self.beautifyKit enable];
            }];
            break;
        }
    // 老美颜
        case VHBeautifyTypeSimple: {
            self.config.beautifyFilterEnable = YES;
            self.publisher = [[VHLivePublisher alloc] initWithConfig:self.config];
            break;
        }
    // 无美颜
        default: {
            self.config.beautifyFilterEnable = NO;
            self.publisher = [[VHLivePublisher alloc] initWithConfig:self.config];
            break;
        }
	}

	self.publisher.delegate = self;
	self.publisher.preView.frame = self.perView.bounds;
	[self.publisher.preView addSubview:self.focusView];
	[self.perView insertSubview:self.publisher.preView atIndex:0];

	[self.publisher setContentMode:VHVideoCaptureContentModeAspectFill];

	//开始视频采集、并显示预览界面
	[self.publisher startCapture];
}

#pragma mark- 推拉流
- (IBAction)startVideoPlayer:(UIButton *)sender {
	if (!self.publisher.isPublishing) {
		[self showProgressDialog:self.perView];
		[_publisher startPublish:self.roomID accessToken:self.accessToken];
	}
	else{
		[self stopPublish];
	}
	_logView.hidden = YES;
}
- (void)stopPublish {
	_bitRateLabel.text = @"";
	[self hideProgressDialog:self.perView];
	_videoStartAndStopBtn.selected = NO;
	[_publisher stopPublish];//停止活动
	_infoView.hidden = YES;
	_closeBtn.hidden = NO;
}
- (BOOL)emCheckMicrophoneAvailability {
	__block BOOL ret = NO;
	AVAudioSession *session = [AVAudioSession sharedInstance];
	if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
		[session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
		         ret = granted;
		 }];
	}
	else {
		ret = YES;
	}
	return ret;
}
- (void)focusGesture:(UITapGestureRecognizer*)gesture {
	CGPoint point = [gesture locationInView:gesture.view];
	[self.publisher focusCameraAtAdjustedPoint:point];
	self.focusView.center = point;
	self.focusView.hidden = NO;
	self.exposureControlView.hidden = !self.exposureControlView.hidden;
	[UIView animateWithDuration:0.3 animations:^{
	         self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
	 } completion:^(BOOL finished) {
	         [UIView animateWithDuration:0.5 animations:^{
	                  self.focusView.transform = CGAffineTransformIdentity;
		  } completion:^(BOOL finished) {
	                  [UIView animateWithDuration:5 animations:^{
	                           self.focusView.hidden = NO;
			   } completion:nil];
		  }];
	 }];
	[self.exposureSlider setValue:0.0];
}

#pragma mark- 侧边栏
- (IBAction)onChangeMirrorPreview:(UISwitch *)sender {
    self.perView.transform = sender.isOn ? CGAffineTransformMakeScale(-1.0, 1.0) : CGAffineTransformIdentity;
}
- (IBAction)onChangeValueForFlash:(UISwitch *)sender {
	[_publisher torchMode:sender.isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
}
- (IBAction)onChangeValueForOnlyVideo:(UISwitch *)sender {
	_publisher.enableMute = sender.isOn;
}
- (IBAction)onChangeValueForSwitchCamera:(UISwitch *)sender {
    [_publisher switchCamera:sender.on ?  AVCaptureDevicePositionBack : AVCaptureDevicePositionFront];
	if(self.publisher.captureDevicePosition == AVCaptureDevicePositionFront) {
        self.flashSwitch.on = NO;
        self.flashSwitch.enabled = NO;
        self.mirrorSwitch.on = NO;
		self.mirrorSwitch.enabled = YES;
	}
	else{
		self.mirrorSwitch.on = NO;
		self.mirrorSwitch.enabled = NO;
        self.flashSwitch.on = NO;
        self.flashSwitch.enabled = YES;
	}
    [self onChangeValueForFlash:self.flashSwitch];
    [self onChangeMirrorPreview:self.mirrorSwitch];
}
- (IBAction)onChangeValueForNoiseReduction:(UISwitch *)sender {
	[_publisher openNoiseSuppresion:sender.on];
}
- (IBAction)onChangeValuedForBeautifySwitch:(UISwitch *)sender {
	self.exposureControlView.hidden = YES;
	self.focusView.hidden = YES;
	self.filterView.hidden = !sender.isOn;
}
- (IBAction)onClickBeautifyOptionSetting:(UIButton *)sender {
	OptionsPresentViewController *opViewController = [[OptionsPresentViewController alloc] init];
	opViewController.beautifykit = self.beautifyKit;
	opViewController.datas = self.beautifyOptions;
	[opViewController registCellNibName:[UINib nibWithNibName:@"OptionRowCell" bundle:nil]];
	opViewController.opbuttons = @[
		[OPButton createWithTitle:@"" handle:nil],
		[OPButton createWithTitle:@"" handle:nil],
	];
	opViewController.handleWillChangeSize = ^(CGSize size){
		CGRect viewFrame = self.perView.bounds;
		if(size.height>50) {
			size.height-=50;
		}
		viewFrame.size.height = self.perView.bounds.size.height - size.height;
		[UIView animateWithDuration:0.25 animations:^{
		         self.publisher.preView.frame = viewFrame;
		 }];
	};
	[self presentViewController:opViewController animated:YES completion:nil];
}
- (IBAction)onClickMuteCameraCapture:(UISwitch *)sender {
    _publisher.cameraMute = sender.on;
}

#pragma mark- 闪光灯
- (void)flashChangeTo:(BOOL)isOn {
	self.flashSwitch.on = self.flashSwitch.isOn != isOn ? isOn : self.flashSwitch.isOn;
	[_publisher torchMode:isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
}

#pragma mark- 曝光补偿
- (IBAction)exposureChange:(UISlider *)sender {
	[self.publisher setExposureTargetBias:sender.value];
}

#pragma mark- VHLivePublisherDelegate
- (void)firstCaptureImage:(UIImage *)image {
	NSLog(@"第一张图片，%dx%d",(int)image.size.width,(int)image.size.height);
}
- (void)onPublishStatus:(VHPublishStatus)status info:(NSDictionary*)info {
	NSLog(@"状态：%ld %@",(long)status,info);
	switch (status) {
	case VHPublishStatusPushConnectSucceed:
		[self hideProgressDialog:self.perView];
		[self showTimeInfo];
		_videoStartAndStopBtn.selected = YES;
		_infoView.hidden = NO;
		_closeBtn.hidden = YES;
		break;
	case VHPublishStatusUploadSpeed:
		_bitRateLabel.text = [NSString stringWithFormat:@"%@ kb/s",info[@"content"]];
		break;
	case VHPublishStatusUploadNetworkException:
		_bitRateLabel.textColor = [UIColor redColor];
		break;
	case VHPublishStatusUploadNetworkOK:
		_bitRateLabel.textColor = [UIColor greenColor];
		break;
	default:
		break;
	}
}
- (void)onPublishError:(VHPublishError)error info:(NSDictionary*)info {
	NSLog(@"错误：%ld %@",(long)error,info);
	[self showMsg:[NSString stringWithFormat:@"%@ %@",info[@"code"],info[@"content"]] afterDelay:2];
	[self stopPublish];
}

#pragma mark- info
- (void)showTimeInfo {
	if(_timer) {
		dispatch_source_cancel(_timer);
		_timer = nil;
	}
	_liveTime = 0;

	__weak typeof(self) wf = self;

	dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
	_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
	dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);//间隔1秒
	dispatch_source_set_event_handler(_timer, ^(){
		wf.liveTime++;
		NSString *strInfo = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",wf.liveTime/3600,(wf.liveTime/60)%60,wf.liveTime%60];
		dispatch_async(dispatch_get_main_queue(), ^{
			if(wf.timeLabel) {
				wf.timeLabel.text = strInfo;
			}
		});
	});
	dispatch_resume(_timer);
}


#pragma mark- 基础美颜控制选项
- (IBAction)filterChange:(UISlider*)sender {
    switch (sender.tag) {
    case 0: _curBeautify = sender.value; break;
    case 1: _curBrightness = sender.value; break;
    case 2: _curSaturation = sender.value; break;
    default: break;
    }
    _curBeautifyLabel.text   = [NSString stringWithFormat:@"磨皮:%.02f",_curBeautify];
    _curBrightnessLabel.text = [NSString stringWithFormat:@"亮度:%.02f",_curBrightness];
    _curSaturationLabel.text = [NSString stringWithFormat:@"饱和度:%.02f",_curSaturation];

    [self.publisher setBeautify:_curBeautify Brightness:_curBrightness Saturation:_curSaturation Sharpness:0.0f];
}



#pragma mark- 高级美颜控制选项
- (NSArray<OptionItem *> *)beautifyOptions {
	if(!_beautifyOptions) {
		_beautifyOptions = @[
			[OptionItem ItemSwitchWithTitle:@"美颜开关" key:@"VHBeautifyEnableOption" value:YES],
			[OptionItem ItemNoneWithTitle:@"------ 基础美颜 ------"],
			[OptionItem ItemSliderWithTitle:@"磨皮" key:eff_key_FU_BlurLevel value:6 min:0 max:6.0],
			[OptionItem ItemSliderWithTitle:@"美白" key:eff_key_FU_ColorLevel value:0.2 min:0.0 max:1.0],
			[OptionItem ItemSliderWithTitle:@"红润" key:eff_key_FU_RedLevel value:0.5 min:0.0 max:1.0],
			[OptionItem ItemSliderWithTitle:@"锐化" key:eff_key_FU_Sharpen value:0.2 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"去黑眼圈" key:eff_key_FU_RemovePouchStrength value:0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"去法令纹" key:eff_key_FU_RemoveNasolabialFoldsStrength value:0 min:0  max:1.0],
			[OptionItem ItemNextWithTitle:@"滤镜" key:eff_key_FU_FilterName value:eff_Filter_Value_FU_origin],
			[OptionItem ItemNoneWithTitle:@"------ 高级美颜 ------"],
//            [OptionItem ItemSliderWithTitle:@"滤镜效果" key:eff_key_FU_FilterLevel value:1.0 min:0.0 max:1.0],
//            [OptionItem ItemSliderWithTitle:@"变形" key:eff_key_FU_FaceShape value:4 min:0  max:4],
//            [OptionItem ItemSliderWithTitle:@"瘦脸" key:eff_key_FU_CheekThinning value:0.0 min:0.0 max:1.0],

//            [OptionItem ItemSliderWithTitle:@"开眼角" key:eff_key_FU_IntensityCanthus value:0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"大眼" key:eff_key_FU_EyeEnlargingV2 value:0.0 min:0 max:1.0],
			[OptionItem ItemSliderWithTitle:@"眼距" key:eff_key_FU_IntensityEyeSpace value:0.5 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"眼睛角度" key:eff_key_FU_IntensityEyeRotate value:0.5 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"亮眼" key:eff_key_FU_EyeBright value:1 min:0  max:1.0],

			[OptionItem ItemSliderWithTitle:@"V脸" key:eff_key_FU_CheekV value:0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"窄脸" key:eff_key_FU_CheekNarrowV2 value:0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"短脸" key:eff_key_FU_CheekShort value:0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"小脸" key:eff_key_FU_CheekSmallV2 value:0 min:0  max:1.0],

//            [OptionItem ItemSliderWithTitle:@"额头调整" key:eff_key_FU_IntensityForeheadV2 value:0.5 min:0 max:1.0],
			[OptionItem ItemSliderWithTitle:@"瘦鼻" key:eff_key_FU_IntensityNoseV2 value:0.0 min:0  max:1.0],
			[OptionItem ItemSliderWithTitle:@"鼻子长度" key:eff_key_FU_IntensityLongNose value:0.5 min:0  max:1.0],

			[OptionItem ItemSliderWithTitle:@"嘴巴调整" key:eff_key_FU_IntensityMouthV2 value:0.5 min:0 max:1.0],

			[OptionItem ItemSliderWithTitle:@"美牙" key:eff_key_FU_ToothWhiten value:1 min:0  max:1.0],

			[OptionItem ItemSliderWithTitle:@"下巴调整" key:eff_key_FU_IntensityChin value:0.5 min:0  max:1.0],

//            [OptionItem ItemSliderWithTitle:@"瘦颧骨" key:eff_key_FU_IntensityCheekbones value:0.0 min:0.0 max:1.0],
//            [OptionItem ItemSliderWithTitle:@"瘦下颌骨" key:eff_key_FU_IntensityLowerJaw value:1 min:0  max:1.0],

//            [OptionItem ItemSliderWithTitle:@"人中调节" key:eff_key_FU_IntensityPhiltrum value:0.5 min:0  max:1.0],
//            [OptionItem ItemSliderWithTitle:@"微笑嘴角" key:eff_key_FU_IntensitySmile value:0 min:0  max:1.0]
		];
	}
	return _beautifyOptions;
}

@end
