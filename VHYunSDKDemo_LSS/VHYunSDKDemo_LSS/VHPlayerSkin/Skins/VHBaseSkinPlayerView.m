//
//  VHBaseSkinPlayerView.m
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHBaseSkinPlayerView.h"
#import "VHPlayerSkinTool.h"
#import "UIView+Fade.h"
#import <MediaPlayer/MediaPlayer.h>

static UISlider * _volumeSlider;

@interface VHBaseSkinPlayerView ()

@property (nonatomic, strong) MPVolumeView *volumeView;

@end


@implementation VHBaseSkinPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.topImageView addSubview:self.returnBtn];
        [self.topImageView addSubview:self.titleLabel];
        [self.bottomImageView addSubview:self.playBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.resolutionBtn];
        [self addSubview:self.loadingView];
        
        //设置默认为直播皮肤
        self.isLive = YES;
        
        // 单例slider
        self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        _volumeSlider = nil;
        for (UIView *view in [self.volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return self;
}

- (void)dealloc {
    [self.volumeView removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 54);
    self.bottomImageView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-54, CGRectGetWidth(self.frame), 54);
    self.returnBtn.frame = CGRectMake(10, 0, 38, CGRectGetHeight(self.topImageView.frame));
    self.fullScreenBtn.frame = CGRectMake(CGRectGetWidth(self.bottomImageView.frame)-15-36, CGRectGetHeight(self.bottomImageView.frame)-36, 36, 36);
    self.playBtn.frame = CGRectMake(15, CGRectGetMidY(self.fullScreenBtn.frame)-36*0.5, 32, 36);
    self.resolutionBtn.frame = CGRectMake(CGRectGetWidth(self.bottomImageView.frame)-15-36, CGRectGetHeight(self.bottomImageView.frame)-36, 36, 36);
    self.loadingView.frame = self.bounds;
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

- (void)setOrientationPortraitConstraint
{
    _isFullScreen = NO;
    
    self.fullScreenBtn.hidden = NO;
    self.returnBtn.hidden = YES;
    self.resolutionBtn.hidden = YES;
    
    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.returnBtn.frame), 0,  CGRectGetWidth(self.topImageView.frame)*0.65, CGRectGetHeight(self.topImageView.frame));
    
    if (!self.isLive) {
        self.vodCurrentTimeLabel.frame = CGRectMake(50, CGRectGetHeight(self.bottomImageView.frame)-9-17, 56,17);
        self.vodTotalTimeLabel.frame = CGRectMake(CGRectGetWidth(self.bottomImageView.frame)-50-56, CGRectGetMinY(self.vodCurrentTimeLabel.frame), 56, 17);
        self.vodSlider.frame = CGRectMake(CGRectGetMaxX(self.vodCurrentTimeLabel.frame)+7, CGRectGetMidY(self.vodCurrentTimeLabel.frame)-CGRectGetHeight(self.vodCurrentTimeLabel.frame)*0.5, CGRectGetWidth(self.bottomImageView.frame)-2*CGRectGetMaxX(self.vodCurrentTimeLabel.frame)-14,20);
        
        self.vodfullScreenTimeLabel.hidden = YES;
        self.vodCurrentTimeLabel.hidden = NO;
        self.vodTotalTimeLabel.hidden = NO;
        self.vodRateBtn.hidden = YES;
    }
}

- (void)setOrientationLandscapeConstraint
{
    _isFullScreen = YES;
    
    self.fullScreenBtn.hidden = YES;
    self.returnBtn.hidden = NO;
    self.resolutionBtn.hidden = NO;
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.returnBtn.frame), 0,  CGRectGetWidth(self.topImageView.frame)*0.65, CGRectGetHeight(self.topImageView.frame));
    
    if (!self.isLive) {
        self.vodRateBtn.frame = CGRectMake(CGRectGetWidth(self.bottomImageView.frame)-78-60, CGRectGetMidY(self.playBtn.frame)-10, 60, 20);
        self.vodfullScreenTimeLabel.frame = CGRectMake(CGRectGetMinX(self.vodCurrentTimeLabel.frame), CGRectGetMidY(self.vodCurrentTimeLabel.frame)-10, 200, 20);
        self.vodSlider.frame = CGRectMake(0, 2, CGRectGetWidth(self.frame),20);
        
        self.vodfullScreenTimeLabel.hidden = NO;
        self.vodCurrentTimeLabel.hidden = YES;
        self.vodTotalTimeLabel.hidden = YES;
        self.vodRateBtn.hidden = NO;
    }
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = [UIImage imageNamed:@"VHSKinBundle.bundle/top_shadow"];
    }
    return _topImageView;
}
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [UIImage imageNamed:@"VHSKinBundle.bundle/bottom_shadow"];
    }
    return _bottomImageView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/暂停"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/播放"] forState:UIControlStateSelected];
        [_playBtn.imageView setContentMode:UIViewContentModeLeft];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/fullscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnBtn setImage:[UIImage imageNamed:@"VHSKinBundle.bundle/returnKey"] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(returnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}
- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _loadingView;
}
- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_returnBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}
- (UIButton *)vodRateBtn {
    if (!_vodRateBtn) {
        _vodRateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _vodRateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_vodRateBtn setTitle:@"1.0x" forState:UIControlStateNormal];
        _vodRateBtn.backgroundColor = [UIColor clearColor];
        [_vodRateBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_vodRateBtn addTarget:self action:@selector(rateBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vodRateBtn;
}
- (VHPlaySlider *)vodSlider {
    if (!_vodSlider) {
        _vodSlider = [[VHPlaySlider alloc] init];
        _vodSlider.delegate = self;
        _vodSlider.value                    = 0;
        _vodSlider.progressView.progress    = 0;
    }
    return _vodSlider;
}
- (UILabel *)vodCurrentTimeLabel {
    if (!_vodCurrentTimeLabel) {
        _vodCurrentTimeLabel               = [[UILabel alloc] init];
        _vodCurrentTimeLabel.textColor     = [UIColor whiteColor];
        _vodCurrentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _vodCurrentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _vodCurrentTimeLabel.text           = @"00:00";
    }
    return _vodCurrentTimeLabel;
}
- (UILabel *)vodTotalTimeLabel {
    if (!_vodTotalTimeLabel) {
        _vodTotalTimeLabel               = [[UILabel alloc] init];
        _vodTotalTimeLabel.textColor     = [UIColor whiteColor];
        _vodTotalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _vodTotalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _vodTotalTimeLabel.text             = @"00:00";
    }
    return _vodTotalTimeLabel;
}
- (UILabel *)vodfullScreenTimeLabel {
    if (!_vodfullScreenTimeLabel) {
        _vodfullScreenTimeLabel               = [[UILabel alloc] init];
        _vodfullScreenTimeLabel.textColor     = [UIColor whiteColor];
        _vodfullScreenTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
    }
    return _vodfullScreenTimeLabel;
}


#pragma mark - private
- (void)rotateScreen:(UIInterfaceOrientation)orientation
{
    //转屏时，先设置支持重力感应，否则此方法无效
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        NSNumber *num = [[NSNumber alloc] initWithInt:orientation];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:) withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    SEL selector=NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation =[NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

#pragma mark - public

- (void)setIsLive:(BOOL)isLive {
    _vodRateBtn.hidden = isLive;
    _vodTotalTimeLabel.hidden = isLive;
    _vodCurrentTimeLabel.hidden = isLive;
    _vodTotalTimeLabel.hidden = isLive;
    _vodSlider.hidden = isLive;
    if (!isLive) {
        [self.bottomImageView addSubview:self.vodRateBtn];
        [self.bottomImageView addSubview:self.vodSlider];
        [self.bottomImageView addSubview:self.vodTotalTimeLabel];
        [self.bottomImageView addSubview:self.vodCurrentTimeLabel];
        [self.bottomImageView addSubview:self.vodfullScreenTimeLabel];
    }
}

+ (UISlider *)volumeViewSlider {
    return _volumeSlider;
}

- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition {

}

- (void)playerStatus:(int)state {
    switch (state) {
        case 0:     //unkown
        {
            [self.loadingView stopAnimating];
            self.playBtn.selected = NO;
        }
            break;
        case 1:     //loading
        {
            [self.loadingView startAnimating];
            self.playBtn.selected = NO;
        }
            break;
        case 2:     //playing
        {
            [self.loadingView stopAnimating];
            self.playBtn.selected = YES;
            [self fadeOut:3];
        }
            break;
        case 3:     //pause
        {
            [self.loadingView stopAnimating];
            self.playBtn.selected = NO;
        }
            break;
        case 4:     //stop
        {
            [self.loadingView stopAnimating];
            self.playBtn.selected = NO;
        }
            break;
        case 5:     //complete
        {
            [self.loadingView stopAnimating];
            self.playBtn.selected = NO;
            if (_isCyclePlay) { //设置循环播放
                [self playBtnClick:self.playBtn];
            }
        }
            break;
        default:
            break;
    }
}
- (void)setProgressTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime playableValue:(CGFloat)playable
{
    if (!self.vodSlider.isDragging) {
        //总时长
        self.vodTotalTimeLabel.text = [VHPlayerSkinTool timeFormat:totalTime];
        //更新当前播放时间
        self.vodCurrentTimeLabel.text = [VHPlayerSkinTool timeFormat:currentTime];
        //全屏显示时间
        self.vodfullScreenTimeLabel.text = [NSString stringWithFormat:@"%@/%@",self.vodCurrentTimeLabel.text,self.vodTotalTimeLabel.text];
        // 更新slider
        self.vodSlider.maximumValue = 100;
        self.vodSlider.minimumValue = 0.0;
        self.vodSlider.value        = currentTime*100/totalTime;
    }
    //更新缓存时长
    [self.vodSlider.progressView setProgress:playable/totalTime animated:NO];
}

- (void)setFullScreen:(BOOL)fullScreen {
    _isFullScreen = fullScreen;
    if (fullScreen) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self rotateScreen:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self rotateScreen:UIInterfaceOrientationLandscapeRight];
        }
    } else {
        [self rotateScreen:UIInterfaceOrientationPortrait];
    }
}
- (void)setCyclePlay:(BOOL)cyclePlay {
    _isCyclePlay = cyclePlay;
}

#pragma mark - action

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(skinViewPlayButtonAction:)]) {
        [self.delegate skinViewPlayButtonAction:self];
    }
}
- (void)fullScreenBtnClick:(UIButton *)sender {
    self.isFullScreen = YES;
    [self fadeOut:3];
}
- (void)returnBtnClick:(UIButton *)sender {
    self.isFullScreen = NO;
}
- (void)resolutionBtnClick:(UIButton *)sender {
    
}
- (void)rateBtnBtnClick:(UIButton *)sender {

}
- (void)sliderTouchBegan:(VHPlaySlider *)slider {
    [self cancelFadeOut];
    if ([self.delegate respondsToSelector:@selector(skinViewSliderTouchBegan:)]) {
        [self.delegate skinViewSliderTouchBegan:self];
    }
}
- (void)sliderValueChanged:(VHPlaySlider *)slider {

}
- (void)sliderTouchEnded:(VHPlaySlider *)slider {
    [self fadeOut:5];
    if ([self.delegate respondsToSelector:@selector(skinViewSliderTouchEnded:currentTime:)]) {
        [self.delegate skinViewSliderTouchEnded:self currentTime:slider.value];
    }
}


@end
