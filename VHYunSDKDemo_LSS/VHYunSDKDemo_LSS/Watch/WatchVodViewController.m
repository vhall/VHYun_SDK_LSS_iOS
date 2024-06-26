//
//  WatchVodViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/24.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "WatchVodViewController.h"
#import <Photos/Photos.h>
#import "DLNAView.h"

#define CONTROLS_SHOW_TIME  10  //底部进度条显示时间

#define DefinitionNameList  (@[@"原画",@"超清",@"高清",@"标清",@"音频"])

@interface WatchVodViewController ()<VHVodPlayerDelegate>
{
	NSTimer *_timer;
	NSArray *_definitionBtns;
	BOOL _enterForegroundPlay; //播放过程中进入后台暂停，进入前台是否自动播放
}
@property (strong, nonatomic) VHVodPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UISlider *curTimeSlider;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *timesBtn;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;
@property (weak, nonatomic) IBOutlet UIView *definitionsView;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn0;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn2;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn3;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn4;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenShareBtn;
@property (nonatomic, strong) DLNAView *dlnaView;
@property (nonatomic, assign) VHVodPlayerSeeekModel seekMode;
@property (nonatomic) NSString * recordID;
@property (nonatomic) NSString * accessToken;
@end

@implementation WatchVodViewController
- (instancetype)initWithRecordID:(NSString *)recordID accessToken:(NSString *)accessToken seekMode:(VHVodPlayerSeeekModel)seekMode {
	if ((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
		self.recordID = recordID;
		self.accessToken = accessToken;
		self.seekMode = seekMode;
	}
	return self;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.

	//阻止iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled: YES];
	_player = [[VHVodPlayer alloc]init];
	_player.delegate = self;
	_player.defaultDefinition = VHDefinitionHD;

	[self.preView insertSubview:_player.view atIndex:0];
	_player.view.frame = _preView.bounds;
	_player.seekModel = self.seekMode;
	[_player startPlay:self.recordID accessToken:self.accessToken];
	[self showProgressDialog:self.preView];

	// 单击的_player.view
	UITapGestureRecognizer* singleRecognizer;
	singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
	singleRecognizer.numberOfTapsRequired = 1; // 单击
	[self.preView addGestureRecognizer:singleRecognizer];

	[_definitionBtn setTitle:DefinitionNameList[0] forState:UIControlStateNormal];
	_definitionsView.hidden = YES;
	_definitionBtns = @[_definitionBtn0,_definitionBtn1,_definitionBtn2,_definitionBtn3,_definitionBtn4];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	_player.view.frame = _preView.bounds;
	_fullscreenBtn.selected = ([UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)dealloc {
	[_player destroyPlayer];
	//允许iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	NSLog(@"%@: dealloc",[self class]);
}

- (IBAction)backBtnClicked:(id)sender {
	[self stopPlayer];
	[_player destroyPlayer];
	[self dismissViewControllerAnimated:YES completion:^{
	 }];
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)stopPlayer {
	[_player stopPlay];
}

- (IBAction)scalingModeBtnClicked:(UIButton *)sender {
	sender.selected = !sender.selected;
	[_player setScalingMode: sender.selected?VHPlayerScalingModeAspectFill:VHPlayerScalingModeAspectFit];
}

- (IBAction)definitionsBtnClicked:(UIButton *)sender {
	_definitionsView.hidden = !_definitionsView.hidden;
}

- (IBAction)definitionBtnClicked:(UIButton *)sender {
	if (sender.selected) return;

	[_player setCurDefinition:sender.tag];
	_definitionsView.hidden = YES;
//    _logView.hidden = (sender.tag != VHDefinitionAudio);
}
- (IBAction)rateBtnClicked:(UIButton *)sender {
	sender.tag+=5;
	if (sender.tag >20)
		sender.tag = 5;

	_player.rate = sender.tag/10.0;
	[sender setTitle:[NSString stringWithFormat:@"%.1f",_player.rate] forState:0];
}
#pragma mark - palyerControls
- (void)showControls:(BOOL)isForever {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
	if (!isForever)
		[self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];

	_bottomView.hidden = NO;
}
- (void)hideControls {
	_bottomView.hidden = YES;
}

- (void)SingleTap:(UITapGestureRecognizer*)recognizer {
	if (_bottomView.hidden)
		[self showControls:(_player.playerState != VHPlayerStatusPlaying)];
	else
		[self hideControls];
}

- (IBAction)playeBtnClicked:(UIButton *)sender {
	if (sender.selected) {
		[_player pause];
		sender.selected = NO;
	}
	else{
		if (_player.playerState == VHPlayerStatusStop || _player.playerState == VHPlayerStatusComplete ) {
			[_player startPlay:self.recordID accessToken:self.accessToken];
			[self showProgressDialog:self.preView];
		}
		else if (_player.playerState == VHPlayerStatusPause) {
			[_player resume];
		}
	}
}
- (IBAction)fullscreenBtnClicked:(UIButton *)sender {
	[self rotateScreen:!sender.selected];
}

- (void)rotateScreen:(BOOL)isLandscapeRight {
	if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
		NSNumber *num = [[NSNumber alloc] initWithInt:(isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
		[[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
		[UIViewController attemptRotationToDeviceOrientation];
		//这行代码是关键
	}
	SEL selector=NSSelectorFromString(@"setOrientation:");
	NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
	[invocation setSelector:selector];
	[invocation setTarget:[UIDevice currentDevice]];
	int val =isLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
	[invocation setArgument:&val atIndex:2];
	[invocation invoke];
	[[UIApplication sharedApplication] setStatusBarHidden:isLandscapeRight withAnimation:UIStatusBarAnimationSlide];
}

- (IBAction)curTimeValueChange:(id)sender {
	_minLabel.text = [self timeFormat:_player.duration*_curTimeSlider.value];
}

- (IBAction)durationSliderTouchBegan:(UISlider *)slider {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
	[_player pause];
}

- (IBAction)durationSliderTouchEnded:(UISlider *)slider {
	_player.currentPlaybackTime = _player.duration*_curTimeSlider.value;
	[_player resume];
	[self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];
}
- (IBAction)takeAPhotoBtnClicked:(UIButton*)sender {
	__weak typeof(self) wf = self;
	[_player takeVideoScreenshot:^(UIImage *image) {
	         if (image) {
			 dispatch_async(dispatch_get_main_queue(), ^{
						[wf saveImage:image];
					});
		 }
	 }];
}

- (IBAction)muteBtnClicked:(UIButton*)sender {
	sender.selected =  !sender.selected;
	_player.mute = sender.selected;
}

- (void)saveImage:(UIImage *)image {
	[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
	         PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
	 } completionHandler:^(BOOL success, NSError * _Nullable error) {
	         NSLog(@"success = %d, error = %@", success, error);
	         NSString*ret = @"已保存到相册";
	         if (!success && error.userInfo[@"NSLocalizedDescription"])
			 ret = error.userInfo[@"NSLocalizedDescription"];
	         [self showMsg:ret afterDelay:2];
	 }];
}

- (IBAction)screenShareBtnClicked:(UIButton *)sender {
//    sender.selected = !sender.selected;

//    if (!self.isCast_screen) {
//        [self showMsg:@"无投屏权限，如需使用请咨询您的销售人员或拨打客服电话：400-888-9970" afterDelay:1];
//        return;
//    }
	if (![self.dlnaView showInView:self.view moviePlayer:self.player]) {
		[self showMsg:@"投屏失败，投屏前请确保当前视频正在播放" afterDelay:1];
		return;
	}

	[self.player pause];

	__weak typeof(self) wf = self;
	self.dlnaView.closeBlock = ^{
		[wf.player resume];
	};
}
- (IBAction)openPIP:(UIButton *)sender {

	sender.selected =  !sender.selected;

	if (sender.selected) {
		[self.player openPIPSupported];
	}
	else{
		[self.player closePIPSupported];
	}
}

- (DLNAView *)dlnaView {
	if (!_dlnaView) {
		_dlnaView = [[DLNAView alloc] initWithFrame:self.view.bounds];
		_dlnaView.delegate = self;
	}
	return _dlnaView;
}

#pragma mark - VHVodPlayerDelegate
- (void)player:(VHVodPlayer *)player statusDidChange:(VHPlayerStatus)state {
	switch (state) {
	    case VHPlayerStatusLoading:
	    {
		    [self showProgressDialog:self.preView];
	    }
	    break;
	    case VHPlayerStatusPlaying:
	    {
		    _rateBtn.tag = (NSInteger)(_player.rate*10.0);
		    [_rateBtn setTitle:[NSString stringWithFormat:@"%.1f",_player.rate] forState:0];
		    [self showControls:NO];
		    _playBtn.selected = YES;
		    [self hideProgressDialog:self.preView];
	    }
	    break;
	    case VHPlayerStatusStop:
	    {
		    [self showControls:YES];
		    _playBtn.selected = NO;
		    [self hideProgressDialog:self.preView];
	    }
	    break;
	    case VHPlayerStatusPause:
		    _playBtn.selected = NO;
		    break;

	    default:
		    break;
	}
}

- (void)player:(VHVodPlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition {
	NSLog(@"curDefinition: %ld definitions:%@",(long)definition,definitions);

	[_definitionBtn setTitle:DefinitionNameList[definition] forState:UIControlStateNormal];
	for (UIButton* btn in _definitionBtns) {
		btn.enabled = NO;
	}

	for (NSNumber *idx in definitions) {
		UIButton* btn  = _definitionBtns[[idx integerValue]];
		btn.enabled = YES;
		btn.selected = (definition == [idx integerValue]);
	}
}

- (void)player:(VHVodPlayer *)player stoppedWithError:(NSError *)error {
	//允许iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	[self hideProgressDialog:self.preView];
	[self stopPlayer];
	[self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}

- (void)player:(VHVodPlayer*)player currentTime:(NSTimeInterval)currentTime {
	if (_player.playerState == VHPlayerStatusPlaying) {
		_minLabel.text = [self timeFormat:_player.currentPlaybackTime];
		_maxLabel.text = [self timeFormat:_player.duration];
		if (_player.duration>0)
			_curTimeSlider.value =_player.currentPlaybackTime/_player.duration;
	}
}

- (void)player:(VHVodPlayer*)player videoSize:(CGSize)size {
	NSLog(@"video size: %@",NSStringFromCGSize(size));
}

//打点数据
- (void)player:(VHVodPlayer *)player videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr {

}

- (BOOL)shouldAutorotate {
	return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;

}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}

- (IBAction)rateBtn:(id)sender {
}
@end
