//
//  WatchTimeshiftViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by 郭超 on 2021/8/16.
//  Copyright © 2021 vhall. All rights reserved.
//

#import "WatchTimeshiftViewController.h"
#import <VHLSS/VHTimeshiftPlayer.h>
#define CONTROLS_SHOW_TIME  10  //底部进度条显示时间

#define DefinitionNameList  (@[@"原画",@"超清",@"高清",@"标清",@"音频"])

@interface WatchTimeshiftViewController ()<VHTimeshiftPlayerDelegate>
{
    NSTimer         *_timer;
    NSArray *_definitionBtns;
    BOOL _enterForegroundPlay; //播放过程中进入后台暂停，进入前台是否自动播放
}
@property (strong, nonatomic)VHTimeshiftPlayer *player;

@property (weak, nonatomic) IBOutlet UIView *preView;


@property (weak, nonatomic) IBOutlet UIView   *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel  *minLabel;
@property (weak, nonatomic) IBOutlet UISlider *curTimeSlider;
@property (weak, nonatomic) IBOutlet UIButton *fullscreenBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeshiftButton;

@property (weak, nonatomic) IBOutlet UIButton *definitionBtn;

@property (weak, nonatomic) IBOutlet UIView   *definitionsView;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn0;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn1;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn2;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn3;
@property (weak, nonatomic) IBOutlet UIButton *definitionBtn4;

@property (nonatomic, assign) BOOL  isChangeSlider;
@property (nonatomic, assign) NSTimeInterval  currentTime;
@end

@implementation WatchTimeshiftViewController

//进入后台
- (void)appDidEnterBackground {
    if(self.player.playerState == VHPlayerStatusPlaying) {
        _enterForegroundPlay = YES;
        [self.player pause];
    }
}

//进入前台
- (void)appWillEnterForeground {
    if(_enterForegroundPlay) {
        [self.player resume];
        _enterForegroundPlay = NO;
    }
}

- (IBAction)backBtnClicked:(id)sender {
    [self stopPlayer];
    [_player destroyPlayer];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //前后台监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //阻止iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    self.player = [[VHTimeshiftPlayer alloc]init];
    _player.delegate = self;
    _player.defaultDefinition = VHDefinitionHD;
    
    [self.preView insertSubview:_player.view atIndex:0];
    _player.view.frame = _preView.bounds;
    [_player startLivePlay:self.roomId delay:90 accessToken:self.accessToken];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _player.view.frame = _preView.bounds;
    _fullscreenBtn.selected = ([UIApplication sharedApplication].statusBarOrientation != UIDeviceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_player destroyPlayer];
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    NSLog(@"%@: dealloc",[self class]);
}

- (IBAction)definitionsBtnClicked:(UIButton *)sender {
    _definitionsView.hidden = !_definitionsView.hidden;
}

- (IBAction)definitionBtnClicked:(UIButton *)sender {
    if(sender.selected) return;
    
    [_player setCurDefinition:sender.tag];
    _definitionsView.hidden = YES;
//    _logView.hidden = (sender.tag != VHDefinitionAudio);
}
- (IBAction)muteBtnClicked:(UIButton*)sender {
    sender.selected =  !sender.selected;
    _player.mute = sender.selected;
}
- (IBAction)playeBtnClicked:(UIButton *)sender {
    if(sender.selected)
    {
        [_player pause];
        sender.selected = NO;
    }
    else
    {
        if(_player.playerState == VHPlayerStatusStop || _player.playerState == VHPlayerStatusComplete )
        {
            [_player startLivePlay:self.roomId delay:90 accessToken:self.accessToken];
            [self showProgressDialog:self.preView];
        }
        else if(_player.playerState == VHPlayerStatusPause)
        {
            [_player resume];
        }
    }
}
#pragma mark - 返回直播
- (IBAction)timeshiftBtn:(UIButton *)sender {
    self.isChangeSlider = NO;
    [_player startLivePlay:self.roomId delay:sender.selected ? 0 : 90 accessToken:self.accessToken];
}
- (IBAction)fullscreenBtnClicked:(UIButton *)sender {
    [self rotateScreen:!sender.selected];
}

- (void)rotateScreen:(BOOL)isLandscapeRight
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
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
    _minLabel.text = [self timeFormat:_player.live_duration*_curTimeSlider.value];
}

- (IBAction)durationSliderTouchBegan:(UISlider *)slider {
    self.isChangeSlider = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
    [_player pause];
}

- (IBAction)durationSliderTouchEnded:(UISlider *)slider {
    NSLog(@"时间 === %f",self.currentTime - slider.value * self.currentTime);
    [_player startLivePlay:self.roomId delay:self.currentTime - slider.value * self.currentTime accessToken:self.accessToken];
    [self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    if(_bottomView.hidden)
        [self showControls:(_player.playerState != VHPlayerStatusPlaying)];
    else
        [self hideControls];
}

#pragma mark - VHTimeshiftPlayerDelegate

- (void)player:(VHTimeshiftPlayer *)player statusDidChange:(VHPlayerStatus)state
{
    switch (state) {
        case VHPlayerStatusLoading:
        {
            [self showProgressDialog:self.preView];
        }
            break;
        case VHPlayerStatusPlaying:
        {
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
- (void)player:(VHTimeshiftPlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition
{
    
}
- (void)player:(VHTimeshiftPlayer*)player currentTime:(NSTimeInterval)currentTime
{
    if(_player.playerState == VHPlayerStatusPlaying)
    {
        self.currentTime = currentTime + player.live_duration;

        _minLabel.text = [self timeFormat:self.currentTime];
        
        if (!self.isChangeSlider) {
            _curTimeSlider.value = self.currentTime;
        }
    }
}
- (void)player:(VHTimeshiftPlayer *)player stoppedWithError:(NSError *)error
{
    //允许iOS设备锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self hideProgressDialog:self.preView];
    [self stopPlayer];
    [self showMsg:[NSString stringWithFormat:@"%@",error.domain] afterDelay:2];
}
- (void)showControls:(BOOL)isForever
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls) object:nil];
    if(!isForever)
        [self performSelector:@selector(hideControls) withObject:nil afterDelay:CONTROLS_SHOW_TIME];
    
    _bottomView.hidden = NO;
}
- (void)hideControls
{
    _bottomView.hidden = YES;
}
- (void)stopPlayer
{
    [_player stopPlay];
}


@end
