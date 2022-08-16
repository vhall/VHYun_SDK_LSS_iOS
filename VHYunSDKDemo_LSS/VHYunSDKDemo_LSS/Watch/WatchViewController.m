//
//  WatchViewController.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "WatchViewController.h"
#import <VHLSS/VHLivePlayer.h>
#import <Photos/Photos.h>
#import <VHCore/VHMessage.h>
#import "DLNAView.h"
#import "BottomOptionsController.h"
///// 使用快直播
//#if __has_include(<VHRTC/VHRenderView.h>)
//    #import <VHRTC/VHRenderView.h>
//#endif

//#define DefinitionNameList  (@[@"原画",@"超清",@"高清",@"标清",@"音频"])

@interface WatchViewController ()<VHLivePlayerDelegate>
{
	int loadingCnt;
}
@property (strong, nonatomic) VHLivePlayer *player;
@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIImageView *logView;
@property (weak, nonatomic) IBOutlet UIButton *stratBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadSpeedLabel;

@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;
@property (nonatomic) NSArray<OptItem *> *definitionList;
@property (nonatomic) NSUInteger definitionSelectedIndex;

@property (weak, nonatomic) IBOutlet UIButton *scalingButton;
@property (nonatomic) NSArray<OptItem *> *scalingList;
@property (nonatomic) NSUInteger scalingSelectedIndex;

@property (weak, nonatomic) IBOutlet UIStackView *stack_operation;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *screenShareBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtitle_btn;
@property (weak, nonatomic) IBOutlet UISwitch *switch_resolution;
@property (nonatomic,strong)   DLNAView           *dlnaView;
@property (nonatomic,copy) NSString * roomId;
@property (nonatomic) NSString *interactId;
@property (nonatomic,copy) NSString * accessToken;
@property (nonatomic, assign) NSInteger bufferTime;
@end

@implementation WatchViewController

- (instancetype)initWithRoomID:(NSString *)lssID accessToken:(NSString *)accessToken BufferTime:(NSInteger)bufferTime {
    if((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.roomId = lssID;
        self.accessToken = accessToken;
        self.bufferTime = bufferTime;
    }
    return self;
}
- (instancetype)initWithRoomID:(NSString *)lssID interactID:(NSString *)inavID accessToken:(NSString *)accessToken BufferTime:(NSInteger)bufferTime {
    if((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.roomId = lssID;
        self.interactId = inavID;
        self.accessToken = accessToken;
        self.bufferTime = bufferTime;
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.

	//阻止iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    self.player = [[VHLivePlayer alloc]init];
    self.switch_resolution.enabled = NO;
//#if __has_include(<VHRTC/VHRenderView.h>)
//    self.switch_resolution.enabled = YES;
//    self.switch_resolution.on = YES;    // 快直播默认为大流
//    self.player.fastLiveID = self.interactId;
//    self.player.fastLiveRTCPlayer = [VHRenderView fastLivePlayer];
//#endif
	self.player.delegate = self;
	self.player.bufferTime = self.bufferTime;
	self.player.defaultDefinition = VHDefinitionHD;
	self.player.default_live_subtitle = NO;
	[self.preView insertSubview:self.player.view atIndex:0];
	self.player.view.frame = CGRectMake(0, 0, _preView.bounds.size.width,_preView.bounds.size.width/16*9);
	self.stack_operation.hidden = YES;
	[self stratBtnClicked:nil];
    self.scalingSelectedIndex = 1;
}
- (void)viewDidLayoutSubviews {
    self.player.view.frame = CGRectMake(0, 0, _preView.bounds.size.width,_preView.bounds.size.width/16*9);
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (void)dealloc {
	//允许iOS设备锁屏
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	NSLog(@"%@: dealloc",[self class]);
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
- (void)stopPlayer {
	_logView.hidden = NO;
	_stratBtn.selected = NO;
	self.stack_operation.hidden = YES;
	[self.player stopPlay];
}
- (IBAction)backBtnClicked:(id)sender {
	if (self.player.playerState != VHPlayerStatusStop) {
		[self stopPlayer];
	}
	[self.player destroyPlayer];
	[self dismissViewControllerAnimated:YES completion:^{
	 }];
	[self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)stratBtnClicked:(UIButton *)sender {
	if (!_stratBtn.selected) {
		//设备锁屏
		[[UIApplication sharedApplication] setIdleTimerDisabled: YES];
		[self showProgressDialog:self.preView];
		_logView.hidden = YES;
		_infoLabel.text = @"";
		loadingCnt = 0;
        [self.player startPlay:self.roomId accessToken:self.accessToken];
	}
	else{
		[self stopPlayer];
	}
}
- (IBAction)takeAPhotoBtnClicked:(id)sender {

	__weak typeof(self) wf = self;
	[self.player takeVideoScreenshot:^(UIImage *image) {
	         if (image) {
			 dispatch_async(dispatch_get_main_queue(), ^{
						[wf saveImage:image];
					});
		 }
	 }];
}
- (IBAction)onSwitchChangeMute:(UISwitch *)sender {
	self.player.mute = sender.on;
}

#pragma mark- 切换清晰度
- (NSArray<OptItem *> *)definitionList {
    if(!_definitionList) {
        _definitionList = @[
            [OptItem itemWithTitle:@"原画"],
            [OptItem itemWithTitle:@"超高清\n720p"],
            [OptItem itemWithTitle:@"高清\n480p"],
            [OptItem itemWithTitle:@"标清\n360p"],
            [OptItem itemWithTitle:@"纯音频"],
            [OptItem itemWithTitle:@"竖屏"],
            [OptItem itemWithTitle:@"1080p"]
        ];
        [_definitionList enumerateObjectsUsingBlock:^(OptItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.available = NO;
        }];
    }
    return _definitionList;
}
- (IBAction)onClickDefinitionButton:(UIButton *)sender {
    BottomOptionsController *options = [[BottomOptionsController alloc] initWithTitle:@"调整分辨率" dataSource:self.definitionList];
    options.handleOnClickSure = ^(NSIndexPath *indexPath) {
        [self definitionChangeIndex:indexPath.row];
    };
    options.selectedIndexPath = [NSIndexPath indexPathForRow:self.definitionSelectedIndex inSection:0];
    [options showinViewController:self];
}
- (void)definitionChangeIndex:(NSUInteger)selectedIndex {
    if(self.definitionSelectedIndex == selectedIndex) {
        showToastMsg(@"当前清晰度已经是:%@", self.definitionList[self.definitionSelectedIndex].title);
        return;
    }
    [self.player setCurDefinition:selectedIndex];
    _logView.hidden = (selectedIndex != VHDefinitionAudio);
}
- (void)player:(VHLivePlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition {
    __block BOOL available_definition = NO;
    [definitions enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(definition == obj.intValue) {
            available_definition = YES;
        }
    }];
    if(available_definition) {
        showToastMsg(@"当前分辨率为 : %@", self.definitionList[(int)definition].title);
        self.definitionSelectedIndex = definition;
    }
    [definitions enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.definitionList[[obj unsignedIntegerValue]].available = YES;
    }];
}

# pragma mark- 画面适应状态
- (NSArray<OptItem *> *)scalingList {
    if(!_scalingList) {
        _scalingList = @[
            [OptItem itemWithTitle:@"拉伸(Fill)"],
            [OptItem itemWithTitle:@"等比黑边缩放(AspectFit)"],
            [OptItem itemWithTitle:@"等比裁切缩放(AspectFill)"]
        ];
    }
    return _scalingList;
}
- (IBAction)onClickScalingModeButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    BottomOptionsController *options = [[BottomOptionsController alloc] initWithTitle:@"调整画面" dataSource:self.scalingList];
    options.handleOnClickSure = ^(NSIndexPath *indexPath) {
        [self scalingChangeIndex:indexPath.row];
    };
    options.selectedIndexPath = [NSIndexPath indexPathForRow:self.scalingSelectedIndex inSection:0];
    [options showinViewController:self];
}
- (void)scalingChangeIndex:(NSUInteger)selectIndex {
    [self.player setScalingMode:(int)selectIndex];
    self.scalingSelectedIndex = selectIndex;
    switch (selectIndex) {
        case VHPlayerScalingModeFill:
            showToastMsg(@"画面调整为：VHPlayerScalingModeFill");
            break;
        case VHPlayerScalingModeAspectFit:
            showToastMsg(@"画面调整为：VHPlayerScalingModeAspectFit");
            break;
        case VHPlayerScalingModeAspectFill:
            showToastMsg(@"画面调整为：VHPlayerScalingModeAspectFill");
            break;
    }
}

# pragma mark- 屏幕截图
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
- (IBAction)onSwitchChangeResolution:(UISwitch *)sender {
    sender.enabled = false;
	self.player.resolution = (int)sender.on;
}
- (DLNAView *)dlnaView {
	if (!_dlnaView) {
		_dlnaView = [[DLNAView alloc] initWithFrame:self.view.bounds];
		_dlnaView.delegate = self;
	}
	return _dlnaView;
}
- (IBAction)selectSubtitle:(UIButton *)sender {
	sender.selected = !sender.selected;
	self.player.live_subtitle = sender.selected;
}

#pragma mark - VHLssPlayerDelegate
- (void)player:(VHLivePlayer *)player willReconnect:(int)lastCount {
    showToastMsg([NSString stringWithFormat:@"重新连接 : %d", lastCount]);
}
- (void)player:(VHLivePlayer *)player statusDidChange:(int)state {
	_logView.hidden = (self.player.curDefinition != VHDefinitionAudio);
	switch (state) {
	    case VHPlayerStatusLoading:
            showToastMsg(@"开始加载");
		    self.stack_operation.hidden = NO;
		    _stratBtn.selected = YES;
		    loadingCnt++;
		    [self showProgressDialog:self.preView];
		    break;
	    case VHPlayerStatusPlaying:
            showToastMsg(@"开始播放");
		    self.stack_operation.hidden = NO;
		    _stratBtn.selected = YES;
		    [self hideProgressDialog:self.preView];
		    break;
	    case VHPlayerStatusStop:
            showToastMsg(@"播放停止");
		    _logView.hidden = NO;
		    _stratBtn.selected = NO;
		    self.stack_operation.hidden = YES;
		    [self hideProgressDialog:self.preView];
		    break;
	    case VHPlayerStatusPause:
            showToastMsg(@"播放暂停");
		    break;
	    case VHPlayerStatusfpReconnect:
            showToastMsg(@"重新连接");
		    break;
        case VHPlayerStatusfpConnectFailed:
            showToastMsg(@"连接失败");
            break;
        case VHPlayerStatusfpVideoChangefailed:
            showToastMsg(@"切换清晰度成功");
            break;
        case VHPlayerStatusfpVideoChangeSucceed:
            showToastMsg(@"切换清晰度失败");
            break;
	    default:
		    break;
	}
}
- (void)player:(VHLivePlayer *)player stoppedWithError:(NSError *)error {
	showToastMsg([NSString stringWithFormat:@"(%lu)%@", error.code, error.domain]);
	[self hideProgressDialog:self.preView];
	[self stopPlayer];
	[self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}
- (void)player:(VHLivePlayer *)player downloadSpeed:(NSString*)speed {
	_downloadSpeedLabel.text = [NSString stringWithFormat:@"%@ kb/s(%d)",speed,loadingCnt];

//测试代码
	if ([speed rangeOfString:@"-"].location == NSNotFound)
		_downloadSpeedLabel.text = [NSString stringWithFormat:@"%@ kb/s(%d)",speed,loadingCnt];
	else{
		NSRange r = [speed rangeOfString:@"_" options:NSBackwardsSearch];
		if (r.location != NSNotFound)
			_infoLabel.text = [_infoLabel.text stringByAppendingFormat:@"\n%@",[speed substringToIndex:r.location]];
	}
}
- (void)player:(VHLivePlayer *)player streamtype:(int)streamtype {
	NSLog(@"streamtype: %ld",(long)streamtype);
}
- (void)player:(VHLivePlayer *)player roomMessage:(id)msg {
	VHMessage *roommsg = (VHMessage *)msg;
	if ([roommsg.service_type isEqualToString:MSG_Service_Type_Room]) {
		if ([roommsg.data[MSG_Type] isEqualToString:MSG_Room_Live_Start]) {
			[self showMsg:@"主持人已开始推流" afterDelay:1.5];
		}
		else if ([roommsg.data[MSG_Type] isEqualToString:MSG_Room_Live_Over]) {
			[self hideProgressDialog:self.preView];
			[self stopPlayer];
			[self showMsg:@"主持人没有推流" afterDelay:1.5];
		}
	}
	else if ([roommsg.service_type isEqualToString:MSG_Service_Type_Online]) {
		NSLog(@"直播间pv: %ld uv:%ld",(long)roommsg.pv,(long)roommsg.uv);
	}
}
- (void)player:(VHLivePlayer*)player videoSize:(CGSize)size {
	NSLog(@"video size: %@",NSStringFromCGSize(size));
}
- (void)player:(VHLivePlayer*)player videoSize:(CGSize)size resolution:(int)resolution {
    NSLog(@"-fast-Resolution Changed: (%.0f, %.0f), %d", size.width, size.height, resolution);
    showToastMsg(@"Resolution Changed: (%.0f, %.0f), %d", size.width, size.height, resolution);
    self.switch_resolution.enabled = YES;
}
- (void)player:(VHLivePlayer*)player isLiveSubtitle:(BOOL)isLiveSubtitle {
	self.subtitle_btn.hidden = !isLiveSubtitle;
}

#pragma mark - shouldAutorotate
- (BOOL)shouldAutorotate {
	return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;

}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}
@end
