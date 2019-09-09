//
//  VHBaseSkinPlayerView.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <VHLSS/VHPlayerSkinView.h>
#import "VHPlaySlider.h"

NS_ASSUME_NONNULL_BEGIN

///播放器皮肤类父类，定义公用的代理指针，公用的按钮等。

@interface VHBaseSkinPlayerView : VHPlayerSkinView <VHPlaySliderDelegate>

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame;


/// 设置皮肤类型，默认为YES，YES：设置为直播皮肤，NO：设置为点播皮肤
@property (nonatomic) BOOL isLive;


/// 以下实例已创建，通过继承实现多态，子类如不适用直接隐藏即可。
//底部shadow
@property (nonatomic, strong) UIImageView *bottomImageView;
//顶部shadow
@property (nonatomic, strong) UIImageView *topImageView;
//播放按钮
@property (nonatomic, strong) UIButton *playBtn;
//全屏按钮（全屏时候隐藏）
@property (nonatomic, strong) UIButton *fullScreenBtn;
//切换分辨率按钮（竖屏时候隐藏）
@property (nonatomic, strong) UIButton *resolutionBtn;
//标题label
@property (nonatomic, strong) UILabel *titleLabel;
//返回按钮（竖屏隐藏）
@property (nonatomic, strong) UIButton *returnBtn;
//loading
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
//倍速按钮(直播时候隐藏)
@property (nonatomic, strong) UIButton *vodRateBtn;
//滑竿(直播时候隐藏)
@property (nonatomic, strong) VHPlaySlider *vodSlider;
//当前播放时长label(直播时候隐藏)
@property (nonatomic, strong) UILabel *vodCurrentTimeLabel;
//视频总时长label(直播时候隐藏)
@property (nonatomic, strong) UILabel *vodTotalTimeLabel;
//横屏时播放时间显示(直播时候隐藏)
@property (nonatomic, strong) UILabel *vodfullScreenTimeLabel;

/** 音量调节器 */
@property (class, readonly) UISlider *volumeViewSlider;

/** 是否全屏 */
@property (nonatomic, assign, setter=setFullScreen:) BOOL isFullScreen;

/** 设置循环播放 */
@property (nonatomic, assign, setter=setCyclePlay:) BOOL isCyclePlay;

//播放按钮点击事件
- (void)playBtnClick:(UIButton *)sender;
//全屏按钮点击事件
- (void)fullScreenBtnClick:(UIButton *)sender;
//返回按钮点击事件
- (void)returnBtnClick:(UIButton *)sender;
//分辨率按钮
- (void)resolutionBtnClick:(UIButton *)sender;
//倍速按钮事件
- (void)rateBtnBtnClick:(UIButton *)sender;

//滑竿事件
- (void)sliderTouchBegan:(VHPlaySlider *)slider;
- (void)sliderValueChanged:(VHPlaySlider *)slider;
- (void)sliderTouchEnded:(VHPlaySlider *)slider;
- (void)sliderSignleTouch:(VHPlaySlider *)slider;


///子类继承父类以下两个方法做横竖屏适配
- (void)setOrientationPortraitConstraint;
- (void)setOrientationLandscapeConstraint;


@end


NS_ASSUME_NONNULL_END
