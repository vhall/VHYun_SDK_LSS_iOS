//
//  VHPlayerController.h
//  Demo
//
//  Created by vhall on 2018/12/5.
//  Copyright © 2018 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VHPlayerController;
@class MovieRtcPlayerInterface;
@class VHMarqueeOptionModel;

NS_ASSUME_NONNULL_BEGIN

#define kDispatchDefinitions (@[@"same",@"720p",@"480p",@"360p",@"a",@"916crop",@"1080p"]) //原画、超高清、高清、标清、纯音频、直播答题裁切分辨率,1080p
#define kDispatchTypeRTMP @"rtmp_url"   //直播rtmp
#define kDispatchTypeFLV  @"httpflv_url"//直播flv
#define kDispatchTypeHLSURL  @"hls_url"//直播hls
#define kDispatchTypeHLS  @"hls_domainname"//点播hls
#define kDispatchTypeMP4  @"mp4_domainname"//点播MP4
#define kDispatchTypeTimeshift  @"timeshift"//时移
#define kDispatchTypeTimeshiftSubtitle  @"timeshift_subtitle"//时移字幕

typedef  void (^ScreenshotBlock)(UIImage* image);

typedef NS_ENUM (NSInteger, VHPlayerType) {
	VHPlayerTypeVOD    = 0, // 回放
	VHPlayerTypeLive   = 1, // 直播
	VHPlayerTypeFastLive = 2, // 快直播
    VHPlayerTypePIPLive = 3  // 画中画直播
};

/// 播放器状态
typedef NS_ENUM (NSInteger,VHallPlayerState) {
	VHallPlayerStateUnknow  = 0,    // 初始化时指定的状态，播放器初始化
	VHallPlayerStateLoading = 1,    // 播放器正在加载，正在缓冲
	VHallPlayerStatePlaying = 2,    // 播放器正在播放
	VHallPlayerStatePause   = 3,    // 暂停，当播放器处于播放状态时，调用暂停方法，暂停视频
	VHallPlayerStateStop    = 4,    // 停止，调用stopPlay方法停止本次播放，停止后需再次调用播放方法进行播放
	VHallPlayerStateComplete = 5,   // 本次播放完
	VHallPlayerStatefpReconnect = 6,    // 快直播: 重新连接
	VHallPlayerStatefpVideoChangeSucceed = 7,   // 快直播: 分辨率切换成功
	VHallPlayerStatefpVideoChangefailed = 8,    // 快直播: 分辨率切换失败
	VHallPlayerStatefpConnectFailed = 9 // 快直播: 连接失败 进入重连
};

/// 画面填充模式
typedef NS_ENUM (NSInteger, VHPlayerContentMode) {
	VHPlayerContentModeFill,    // 拉伸至完全填充显示区域
	VHPlayerContentModeAspectFit,// 将图像等比例缩放，适配最长边，缩放后的宽和高都不会超过显示区域，居中显示，画面可能会留有黑边
	VHPlayerContentModeAspectFill,// 将图像等比例铺满整个屏幕，多余部分裁剪掉，此模式下画面不会留黑边，但可能因为部分区域被裁剪而显示不全
};

/// 视频清晰度
typedef NS_ENUM (NSInteger,VHPlayerDefinition) {
	VHPlayerDefinitionOrigin             = 0,//原画
	VHPlayerDefinitionUHD                = 1,//超高清
	VHPlayerDefinitionHD                 = 2,//高清
	VHPlayerDefinitionSD                 = 3,//标清
	VHPlayerDefinitionAudio              = 4,//纯音频
	VHPlayerDefinitionCrop               = 5,//916crop 直播答题裁剪模式
	VHPlayerDefinition1080p              = 6,//1080p 分辨率
};

/// 流类型
typedef NS_ENUM (NSInteger,VHPlayStreamType){
	VHPlayStreamTypeNone = 0,
	VHPlayStreamTypeVideoAndAudio,
	VHPlayStreamTypeOnlyVideo,
	VHPlayTypeOnlyAudio,
};

/// 视频渲染模式
typedef NS_ENUM (int,VHVideoRenderModel){
	VHVideoRenderModelOrigin = 1, //普通视图的渲染
	VHVideoRenderModelVR,      //VR视图的渲染
};

/// 点播视播放器seek模式
typedef NS_ENUM (int,VHPlayerSeeekModel){
	VHPlayerSeeekModelDefault, //默认seek，支持前进和后退seek
	VHPlayerSeeekModelPlayed,  //设置此值后，播放器只支持在播放过的时段seek
};

@protocol VHPlayerControllerDelegate <NSObject>

@optional
/**
 *  观看状态回调
 *  @param player   播放器实例
 *  @param state   状态类型
 */
- (void)player:(VHPlayerController *)player playStateDidChanage:(VHallPlayerState)state;

/**
 *  当前点播支持的清晰度列表
 *  @param definitions   支持的清晰度列表
 *  @param definition    当前播放清晰度
 */
- (void)player:(VHPlayerController *)player validDefinitions:(NSArray <__kindof NSNumber*> *)definitions curDefinition:(VHPlayerDefinition)definition;

/**
 *  错误回调
 *  @param player   播放器实例
 *  @param error    错误
 */
- (void)player:(VHPlayerController *)player didStopWithError:(NSError *)error;


/**
   直播下载速度回调

   @param speed 下载速度 kb/s
 */
- (void)player:(VHPlayerController *)player loadingWithSpeed:(NSString *)speed;
/**
 *  streamtype 直播流类型
 *
 *  @param player       player
 *  @param streamtype   流类型
 */
- (void)player:(VHPlayerController *)player streamtype:(VHPlayStreamType)streamtype;
/**
 *  content msg content
 *
 *  @param player       player
 *  @param content   msg content
 */
- (void)player:(VHPlayerController *)player cuePointAmfMsg:(NSString *)content;

/**
 *  视频宽髙回调
 *  @param player   播放器实例
 *  @param size    当前播放视频宽髙
 */
- (void)player:(VHPlayerController *)player videoSize:(CGSize)size;
- (void)player:(VHPlayerController *)player videoSize:(CGSize)size resolution:(int)resolution;

/**
 *  点播播放时间回调
 *  @param player   播放器实例
 *  @param currentTime    当前播放器时间回调
 */
- (void)player:(VHPlayerController*)player currentTime:(NSTimeInterval)currentTime;

/// 即将开启画中画
- (void)pictureInPictureControllerWillStart;
/// 已经开启画中画
- (void)pictureInPictureControllerDidStart;
/// 开启画中画失败
/// - Parameter error: 错误信息
- (void)pictureInPictureWithFailedToStartPictureInPictureWithError:(NSError *)error;
/// 即将关闭画中画
- (void)pictureInPictureControllerWillStop;
/// 已经关闭画中画
- (void)pictureInPictureControllerDidStop;
/// 关闭画中画且恢复播放界面
/// - Parameter completionHandler: 恢复是否完成。默认设置为YES即可
- (void)pictureInPictureWithRestoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler;
///画中画模式下点击画中画中播放&暂停按键状态变化回调
/// - Parameter  （isPlaying为YES表示播放，NO表示暂停）
- (void)pictureInPicturePlaybackStateDidChange:(BOOL)isPlaying;
/// AVPlayerItemStatusReadyToPlay
/// @param palyer 播放器实例
- (void)playerAble:(VHPlayerController*)palyer;

/// 自定义加密的Key回传给播放器
- (NSString *)keyWithVideo;
@end

///观看直播、点播
// 直播必须设置 setRenderViewModel 而且只设置一次否则会黑屏
@interface VHPlayerController : NSObject

/// 播放事件代理
@property (nonatomic, weak) id <VHPlayerControllerDelegate> delegate;

/// 播放器类型，只读的
@property (nonatomic, readonly) VHPlayerType playerType;

/// 重试次数 默认3次 (仅当 playerType == VHPlayerTypeFastLive 时有效)
@property (nonatomic) NSUInteger retryCount;

/// 剩余重试次数 (仅当 playerType == VHPlayerTypeFastLive 时有效)
@property (nonatomic, readonly) NSInteger lastRetryCount;

/// 播放器状态，只读的
@property (nonatomic,readonly) VHallPlayerState playerState;

/// 播放器播放视图层view
@property (nonatomic, strong, readonly) UIView *view;

/// 播放器水印视图层view
@property (nonatomic, strong, readonly) UIImageView *imageView;

/// 跑马灯
@property (nonatomic, strong) VHMarqueeOptionModel *marqueeOptionConfig;

/// 是否开通实时字幕 1 开通 0 未开通
@property (nonatomic, assign) BOOL live_subtitle;

/// 是否使用字幕视频 [YES 为使用 NO 为不使用 默认为NO 播放开始前设置]
@property (nonatomic, assign) BOOL default_live_subtitle;

/// 是否开通自研实时字幕 1 开通 0 未开通
@property (nonatomic, assign) BOOL live_subtitle_vh;

/// 是否开通mps实时字幕 1 开通 0 未开通
@property (nonatomic, copy) NSString *live_subtitle_mps;

/// 当前播放的清晰度 默认原画 [播放开始后设置]
@property (nonatomic,assign) VHPlayerDefinition curDefinition;

/// 设置默认播放的清晰度 默认原画 [播放开始前设置]
@property (nonatomic,assign) VHPlayerDefinition defaultDefinition;

/// 调度超时时间 默认1000毫秒，单位为毫秒
@property (nonatomic,assign) int timeout;

/// 设置画面的裁剪模式 详见 VHPlayerControllerScalingMode 的定义
@property (nonatomic,assign) VHPlayerContentMode scalingMode;

/// 是否使用直播时移 YES:使用 NO:不使用  默认为NO
@property (nonatomic, assign) BOOL isTimeshift;

/// 直播时移的 时移时间
@property (nonatomic, assign) NSInteger delay;

///使用直播时移 当前播放时长 (直播时移才生效)
@property (nonatomic, assign) NSInteger live_duration;

@property (nonatomic) MovieRtcPlayerInterface *rtcPlayerInterface;

/// seek之后是否还自动播放
@property (nonatomic, assign) BOOL isSeekAutoplay;

/// 是否自动播放
@property (nonatomic, assign) BOOL shouldAutoplay;


- (instancetype)init NS_UNAVAILABLE;

/// 初始化方法
/// @param playerType 播放器类型
+ (instancetype)playerWithType:(VHPlayerType)playerType isOpenPIP:(BOOL)isOpenPIP;
- (instancetype)initWithType:(VHPlayerType)playerType isOpenPIP:(BOOL)isOpenPIP;

/// 开始播放
/// @param streamUrl 流地址，一般是 rtmp、m3u8、MP4地址
- (void)startWithStreamUrl:(NSString *)streamUrl;

/// 开始调度并播放
/// @param dispatchUrl 调度地址 [点播  http://wiki.vhallops.com/pages/viewpage.action?pageId=1409525]
/// @param defaultJson 默认播放地址，即调度服务失效时使用， 具体结构和上方文档一直，但token是计算后的' [json字符串 {"same":[{"hls_domainname/mp4_domainname":"https://xxxxx.e.vhall.com/vhallrecord/xxxxx/xxxxx/record.m3u8?token=计算后的token"}]}]
- (void)startWithDispatchUrl:(NSString*)dispatchUrl default:(nullable NSString*)defaultJson;

/// 开始调度并播放(优先CDN)
/// @param dispatchUrl 调度地址 [点播  http://wiki.vhallops.com/pages/viewpage.action?pageId=1409525]
/// @param defaultJson 默认播放地址，即调度服务失效时使用， 具体结构和上方文档一直，但token是计算后的' [json字符串 {"same":[{"hls_domainname/mp4_domainname":"https://xxxxx.e.vhall.com/vhallrecord/xxxxx/xxxxx/record.m3u8?token=计算后的token"}]}]
- (void)startWithDispatchUrl:(NSString*)dispatchUrl default:(nullable NSString*)defaultJson cdnPriority:(NSString *)cdn;

/// 播放快直播
/// @param dict 快直播所需参数
/// @link 需要设置 rtcPlayerInterface
- (void)startWithParams:(NSDictionary<NSString *, NSString *> *)dict;

/// 直播时移开始播放
/// @param delay 直播时移的时间
/// @param 其余 同<开始调度播放>
- (void)startTimeShiftdelay:(NSInteger)delay dispatchUrl:(NSString*)dispatchUrl default:(nullable NSString*)defaultJson;

/// 停止播放
- (void)stop;

/// 暂停播放
- (void)pause;

/// 恢复播放
- (void)resume;

/// 释放播放器
- (void)destroyPlayer;

/// 视频截屏
- (void)takeVideoScreenshot:(ScreenshotBlock)screenshotBlock;

/// 点播视频 根据时间截屏 直播无效
- (void)takeVideoScreenshot:(NSTimeInterval)time image:(ScreenshotBlock)screenshotBlock;

/**
 * 设置上报日志
 * @param  param 直播日志上报数据结构 根据实际情况调整
 *  "host"：上报地址域名  必传",
 *  "s":"sessionId  必传",
 *  "pf":"平台类型" 0代表iOSAPP 1代表AndroidAPP 2代表flash 3代表wap 4代表IOSSDK 5代表AndroidSDK 6代表小助手
 *  "bu":"区分业务单元，paas=1， saas=0 class=3",
 *  "app_id":"应用ID paas必传"
 *  "uid":"用户id",
 *  "aid":"活动id(房间id)",
 *  "ndi":"设备唯一标志符",
 *  "vid":"直播发起者账号",
 *  "vfid":"直播发起者父账号",
 *  "biz_role":"教育版用户角色"
 *  "biz_id":"教育版业务ID"
 *  "biz_des01":"教育版业务属性"
 *  "biz_des02":"角色状态"
 */
- (void)setLogParam:(NSDictionary *)param;

/// 播放器日志控制台打印开关
/// @param logPrintEnable 默认NO 关闭
- (void)setLogPrintEnable:(BOOL)logPrintEnable;

/// 点播跳转到音视频流某个时间
/// @param time 单位为秒
- (BOOL)seek:(float)time;

/// 点播视播放器seek模式设置 注意：需要播放前调用
@property (nonatomic, assign) VHPlayerSeeekModel seekModel;

/// 点播视播放器seek模式设置 注意：需要播放前调用 [如果是seekModel == VHPlayerSeeekModelPlayed 为指定播放过时间]
- (void)setSeekModel:(VHPlayerSeeekModel)seekModel maxTime:(NSTimeInterval)maxTime;

/// 点播视频总时长
@property (nonatomic, readonly) NSTimeInterval duration;

/// 点播可播放时长
@property (nonatomic, readonly) NSTimeInterval playableDuration;

/// 点播当前播放时间
@property (nonatomic, assign)   NSTimeInterval currentTime;

/// 点播倍速播放速率[0.50, 0.67, 0.80, 1.0, 1.25, 1.50, and 2.0]
@property (nonatomic) float rate;

/// 设置开始播放的位置
@property (nonatomic) NSTimeInterval initialPlaybackTime;
@property (nonatomic, assign) NSInteger bufferTime;//直播缓冲区时间 默认 6秒 必须>0 值越小延时越小,卡顿增加
@property (assign, readonly) int realityBufferTime;//直播实际的缓冲时间 即延迟时间
@property (nonatomic, assign) BOOL mute;//静音/取消

/// 设置是否vr播放 注意不设置会黑屏，仅VR播放时可用
- (void)setRenderViewModel:(VHVideoRenderModel)renderViewModel;

/// 是否使用陀螺仪，仅VR播放时可用
- (void)setUsingGyro:(BOOL)usingGyro;

/// 设置视频布局的方向，切要开启陀螺仪,仅VR模式可用
- (void)setUILayoutOrientation:(UIDeviceOrientation)orientation;

/// 获取原流的播放链接，直播hls，回放hls，点播mp4, 可能返回nil，真正调度后才能取得值
- (NSString*)GetOriginalUrl;

/// 开启画中画
- (BOOL)openPIPSupported;

/// 关闭画中画
- (void)closePIPSupported;

// 是否开启画中画
- (void)setIsOpenPIP:(BOOL)isOpenPIP;
- (void)setPictureInPictureControls:(BOOL)enable;
- (BOOL)getIsOpenPIP;
/// 调用后，应用退到后台时音频会继续播放
- (void)enableBackgroundAudioPlayback;
/// 关闭后台音频播放功能
/// 调用后，应用退到后台时音频会停止播放
- (void)disableBackgroundAudioPlayback;
/// 快直播切换大小流
- (void)fastplayerSetResolution:(NSInteger)resolution;
@end

NS_ASSUME_NONNULL_END
