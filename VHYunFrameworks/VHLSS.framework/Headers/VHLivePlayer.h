//
//  VHLivePlayerSDK.h
//  VHLivePlayerSDK
//
//  Created by vhall on 2017/11/20.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "VHPlayerTypeDef.h"

@class VHDLNAControl;
@class VHPlayerSkinView;
@class MovieRtcPlayerInterface;

/// 观看端错误事件
 
typedef NS_ENUM (NSInteger,VHLivePlayErrorType){
	VHLivePlayErrorNone                 = -1,
	VHivePlayGetUrlError                = 0,//获取服务器rtmpUrl错误
	VHLivePlayParamError                = 1,//参数错误
	VHLivePlayRecvError                 = 2,//接受数据错误
	VHLivePlayCDNConnectError           = 3,//CDN链接失败
	VHLivePlayStopPublish               = 4,//已停止推流
};

@protocol VHLivePlayerDelegate;

@interface VHLivePlayer : NSObject

@property (nonatomic,weak) id <VHLivePlayerDelegate>  delegate;

@property (nonatomic) NSString *fastLiveID;

@property (nonatomic) MovieRtcPlayerInterface *fastLiveRTCPlayer;

@property (nonatomic, readonly) UIView *view;
/// 播放器状态 [详见 VHPlayerStatus 的定义]
@property (nonatomic, readonly) int playerState;
/// 设置缓冲区时间 [秒, 默认6秒 必须>0 值越小延时越小,卡顿增加]
@property (nonatomic) NSInteger bufferTime;
///RTMP链接的超时时间 [默认5000毫秒，单位为毫秒]
@property (nonatomic) int timeout;
/// 获取播放实际的缓冲时间 即延迟时间 单位为毫秒
@property (nonatomic, readonly) int realityBufferTime;
/// 大小流 [快直播的时候有效,默认大流(1)]
@property (nonatomic) NSInteger resolution;
/// 设置默认播放的清晰度 [默认原画]
@property (nonatomic) VHDefinition defaultDefinition;
/// 当前播放的清晰度 [默认原画 只有在播放开始后调用 并在支持的清晰度列表中]
@property (nonatomic) VHDefinition curDefinition;
/// 是否使用字幕视频 [播放开始后设置]
@property (nonatomic) BOOL live_subtitle;
/// 是否使用字幕视频 [播放开始前设置]
@property (nonatomic) BOOL default_live_subtitle;
/// 设置画面的裁剪模式 [详见 VHPlayerScalingMode 的定义]
@property (nonatomic) int scalingMode;
/// 静音
@property (nonatomic) BOOL mute;
/// 重试次数 [默认3]
@property (nonatomic) NSUInteger retryCount;
/// 水印 ImageView 设置水印图片 及显示位置  注：只要使用了改属性 PaaS 控制台设置图片方式便失效
@property (nonatomic, readonly) UIImageView* watermarkImageView;


/// 初始化
- (instancetype)init;

/// 初始化
/// @param logParam log信息
- (instancetype)initWithLogParam:(NSDictionary*)logParam;

/// 开始播放
/// @param roomID       房间ID
/// @param accessToken  accessToken
- (BOOL)startPlay:(NSString *)roomID accessToken:(NSString *)accessToken;


///  暂停播放
- (BOOL)pause;


///  恢复播放
- (BOOL)resume;


///  结束播放
- (BOOL)stopPlay;


///  销毁播放器
- (BOOL)destroyPlayer;


///  获得当前时间视频截图
- (void)takeVideoScreenshot:(void (^)(UIImage* image))screenshotBlock;


/// 设置播放器皮肤
/// @param skinView 播放器皮肤，继承于VHPlayerSkinView的子类view。
/// @discussion 可继承VHPlayerSkinView自定义播放器皮肤，并实现父类的相关方法。也可不使用此方法，完全自定义播放器皮肤并添加到播放器view上。
- (void)setPlayerSkinView:(VHPlayerSkinView *)skinView;


///  获得当前SDK版本号
+ (NSString *)getSDKVersion;

/// 设置投屏对象
/// @param DLNAobj 投屏VHDLNAControl对象
/// @return 是否可投屏
/// @discussion 投屏功能使用步骤：
///     1、设置DLNAobj
///     2、收到DLNAobj设备列表回调后，设置投屏设备
///     3、DLNAobj初始化播放。如果播放过程中多个player使用对同一个DLNAobj，则DLNAobj需要重新初始化播放
- (BOOL)dlnaMappingObject:(VHDLNAControl *)DLNAobj;

@end

@protocol VHLivePlayerDelegate <NSObject>

@optional

///  观看状态回调
///  @param player   播放器实例
///  @param state   状态类型 详见 VHPlayerStatus 的定义.
- (void)player:(VHLivePlayer *)player statusDidChange:(int)state;

///  错误回调
///  @param player   播放器实例
///  @param error    错误
- (void)player:(VHLivePlayer *)player stoppedWithError:(NSError *)error;

///  播放过程中下载速度回调
///  @param player   播放器实例
///  @param speed    kb/s
- (void)player:(VHLivePlayer *)player downloadSpeed:(NSString*)speed;

///  当前房间支持的清晰度列表
///  @param definitions   支持的清晰度列表
///  @param definition    当前播放清晰度
- (void)player:(VHLivePlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition;

///  streamtype 观看流类型
///  @param player       player
///  @param streamtype   观看流类型   1:音频+视频 2:仅视频 3:仅音频
- (void)player:(VHLivePlayer *)player streamtype:(int)streamtype;

///  接收流中消息
///  @param player       player
///  @param msg          流中消息 用于直播答题等消息
- (void)player:(VHLivePlayer *)player receiveMessage:(NSDictionary*)msg;

///  视频宽髙回调
///  @param player      播放器实例
///  @param size        当前播放视频宽髙
///  @param resolution  大小流: 1 大流 2 小流  [快直播使用]
- (void)player:(VHLivePlayer*)player videoSize:(CGSize)size;
- (void)player:(VHLivePlayer*)player videoSize:(CGSize)size resolution:(int)resolution;

///  视频是否开通字幕
///  @param player          播放器实例
///  @param isLiveSubtitle  1 开通 0 未开通
- (void)player:(VHLivePlayer*)player isLiveSubtitle:(BOOL)isLiveSubtitle;

@end
