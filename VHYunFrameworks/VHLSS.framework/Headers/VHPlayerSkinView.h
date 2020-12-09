//
//  VHPlayerSkinView.h
//  VHLive
//
//  Created by vhall on 2019/8/20.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHPlayerTypeDef.h"
#import "VHPlayerCommonModel.h"
NS_ASSUME_NONNULL_BEGIN

@class VHPlayerSkinView;

@protocol VHPlayerSkinViewDelegate <NSObject>

@required

/*! @abstract   点击播放/暂停按钮时，播放器内部实现此回调。
 @param skinView 播放器皮肤类对象
 */
- (void)skinViewPlayButtonAction:(VHPlayerSkinView *)skinView;

/*! @abstract   切换分辨率，播放器内部实现此回调。
 @param skinView 播放器皮肤类对象
 @param definition 分辨率
 */
- (void)skinView:(VHPlayerSkinView *)skinView willChnagedResolution:(NSInteger)definition;

/*! @abstract   切换倍速，播放器内部实现此回调。
 @param skinView 播放器皮肤类对象
 @param rate     倍速
 */
- (void)skinView:(VHPlayerSkinView *)skinView willChnagedPlayRate:(NSInteger)rate;

/*! @abstract   滑竿TouchBegan，播放器内部实现此回调。
 @param skinView 播放器皮肤类对象
 */
- (void)skinViewSliderTouchBegan:(VHPlayerSkinView *)skinView;

/*! @abstract   滑竿TouchEnded，播放器内部实现此回调。
 @param skinView 播放器皮肤类对象
 @param time     slider对应的当前时间
 */
- (void)skinViewSliderTouchEnded:(VHPlayerSkinView *)skinView currentTime:(float)time;

/// 选择字幕，播放器内部实现此回调
/// @param skinView 播放器皮肤类对象
/// @param subtitle 字幕对象
/// @param success 成功，返回字幕详情
/// @param fail 失败
- (void)skinView:(VHPlayerSkinView *)skinView selectSubtitle:(VHVidoeSubtitleModel *)subtitle success:(void(^)(NSArray <VHVidoeSubtitleItemModel *> *subtitleItems))success fail:(void(^)(NSError *error))fail;


/// 是否显示播放器自带字幕，播放器内部实现此回调
/// @param skinView 播放器皮肤类对象
/// @param show 开启字幕
/// @param completion 完成回调，回调当前字幕
- (void)skinView:(VHPlayerSkinView *)skinView showSubtitle:(BOOL)show completion:(void(^)(VHVidoeSubtitleModel *subtitle))completion;

@end


@interface VHPlayerSkinView : UIView


@property (nonatomic, weak) id <VHPlayerSkinViewDelegate> delegate;

/**
 播放状态，接收播放器状态改变事件，子类重写
 */
- (void)playerStatus:(VHPlayerStatus)state;

/**
 播放出错，子类重写
 */
- (void)playerError:(NSError *)error;
/**
 设置支持的分辨率，接收播放器分辨率改变事件，子类重写
 */
- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition;
/**
 播放进度，接收点播播放器播放时间信息，子类重写
 */
- (void)setProgressTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime playableValue:(CGFloat)playable;

/// 获取到视频打点数据，子类重写
/// @param pointArr 打点数据
- (void)videoPointData:(NSArray <VHVidoePointModel *> *)pointArr;

/// 获取到当前视频字幕列表，子类重写
/// @param subtitleArr 字幕列表
- (void)videoSubtitleArr:(NSArray <VHVidoeSubtitleModel *> *)subtitleArr;

///显示控制
- (VHPlayerSkinView *)fadeShow;
///多少秒后隐藏
- (void)fadeOut:(NSTimeInterval)delay;
///取消隐藏
- (void)cancelFadeOut;

@end









NS_ASSUME_NONNULL_END
