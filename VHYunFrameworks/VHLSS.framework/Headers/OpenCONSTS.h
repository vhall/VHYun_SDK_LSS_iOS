//
//  OpenCONSTS.h
//  VHMoviePlayer
//
//  Created by liwenlong on 15/10/14.
//  Copyright © 2015年 vhall. All rights reserved.
//

#ifndef OpenCONSTS_h
#define OpenCONSTS_h
#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
   /**
    *  打开VHall Debug 模式
    *
    *  @param enable true 打开 false 关闭
    */
   extern void EnableVHallDebugModel(BOOL enable);
   /**
    获取sdk版本号
    @return 版本号
    */
   extern NSString *GetMCSDKVersion(void);
#ifdef __cplusplus
}
#endif

//设置摄像头取景方向
typedef NS_ENUM(int,VHallDeviceOrientation){
   kVHallDevicePortrait,
   kVHallDeviceLandSpaceRight,
   kVHallDeviceLandSpaceLeft
};

//直播流格式
typedef NS_ENUM(int,VHallLiveFormat){
   kVHallLiveFormatNone = 0,
   kVHallLiveFormatRtmp,
   kVHallLiveFormatFlV,
   kVHallLiveFormatRtp
};

typedef NS_ENUM(int,VHallVideoResolution){
   kVHallVideoResolution288p = 0,         //       352x288
   kVHallVideoResolution480p,             //       640*480
   kVHallVideoResolution540p,             //       960*540
   kVHallVideoResolution720p,             //       1280*720
   kVHallVideoResolution1080p             //       1920*1080  注意iphone6前置摄像头不支持1080p
};

typedef NS_ENUM(int,LiveStatus){
    kLiveStatusNone           = -1,
    kLiveStatusPushConnectSucceed =0,   //直播连接成功
    kLiveStatusPushConnectError =1,     //直播连接失败
    kLiveStatusCDNConnectSucceed =2,    //播放CDN连接成功
    kLiveStatusCDNConnectError =3,      //播放CDN连接失败
    kLiveStatusBufferingStart = 4,      //播放缓冲开始
    kLiveStatusBufferingStop  = 5,      //播放缓冲结束
    kLiveStatusParamError =6,           //参数错误
    kLiveStatusRecvError =7,            //播放接受数据错误
    kLiveStatusSendError =8,            //直播发送数据错误
    kLiveStatusUploadSpeed =9,          //直播上传速率
    kLiveStatusDownloadSpeed =10,       //播放下载速率
    kLiveStatusNetworkStatus =11,       //保留字段，暂时无用
    kLiveStatusWidthAndHeight =12,      //返回播放视频的宽和高
    kLiveStatusAudioInfo  = 13,          //音频流的信息
    kLiveStatusUploadNetworkException = 14,//发起端网络环境差
    kLiveStatusUploadNetworkOK = 15,     //发起端网络环境恢复正常
    kLiveStatusRecvStreamType = 17,      //接受流的类型
    kLiveStatusVideoQueueFull = 18,
    kLiveStatusAudioQueueFull = 19,
    kLiveStatusVideoEncodeBusy = 20,
    kLiveStatusVideoEncodeOk = 21,
    kLiveStatusReconnecting = 22,
    kLiveStatusOnCuePointAmfMsg = 23,             //live Amf msg
    kLiveStatusAudioRecoderError  =24,  //音频采集失败，提示用户查看权限或者重新推流，切记此事件会回调多次，直到音频采集正常为止
	kLiveStatusUploadTrueSpeed = 31,	// 区别于 kLiveStatusUploadSpeed 的实际成功发送码率，本条表示尝试发送数据码率，包含发送失败数据
};

typedef NS_ENUM(int,VHallLivePlayErrorType){
   kVHallLivePlayParamError = kLiveStatusParamError,          //参数错误
   kVHallLivePlayRecvError  = kLiveStatusRecvError,           //接受数据错误
   kVHallLivePlayCDNConnectError = kLiveStatusCDNConnectError,//CDN链接失败
   kVHallLivePlayJsonFormalError = 15                         //返回json格式错误
};

//Rtc 播放器消息事件、状态
typedef NS_ENUM(int,VHallRtcPlayStatus){
     kRtcLiveStatusNone           = -100,
     kRtcLiveStatusPullConnectSucceed =101,   //播放连接成功
     kRtcLiveStatusPullConnectError =102,     //播放连接失败
     kRtcLiveStatusPullReConnect =103,     //播放开始重连
     kRtcLiveStatusParamError =104,           //参数错误
     
     kRtcLiveStatusVideoChangeSucceed =105,           //切换分辨率成功
     kRtcLiveStatusVideoChangeError =106,           //切换分辨率成功
     kRtcLiveStatusVideoChangeSendSucceed =107,           //切换分辨率发送请求
};

//RTMP 播放器View的缩放状态
typedef NS_ENUM(int,VHallRTMPMovieScalingMode){
   kVHallRTMPMovieScalingModeNone,       // No scaling
   kVHallRTMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
   kVHallRTMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
};

//流类型
typedef NS_ENUM(int,VHallStreamType){
   kVHallStreamTypeNone = 0,
   kVHallStreamTypeVideoAndAudio,
   kVHallStreamTypeOnlyVideo,
   kVHallStreamTypeOnlyAudio,
};

typedef NS_ENUM(int,VHallRenderModel){
   kVHallRenderModelNone = 0,
   kVHallRenderModelOrigin,  //普通视图的渲染
   kVHallRenderModelDewarpVR, //VR视图的渲染
};

@protocol VHLivePushDelegate <NSObject>
/**
 *  发起直播时的状态
 *
 *  @param liveStatus 直播状态
 */
-(void)onEvent:(LiveStatus)liveStatus withInfo:(NSDictionary*)info;

/**
 * 当liveStatus == kLiveStatusPushConnectError时，content代表出错原因
 * 4001   握手失败
 * 4002   链接vhost/app失败
 * 4003   网络断开 （预留，暂时未使用）
 * 4004   无效token
 * 4005   不再白名单中
 * 4006   在黑名单中
 * 4007   流已经存在
 * 4008   流被禁掉 （预留，暂时未使用）
 * 4009   不支持的视频分辨率（预留，暂时未使用）
 * 4010   不支持的音频采样率（预留，暂时未使用）
 * 4011   欠费
 */
@end

@class VHMoviePlayer;

@protocol VHMoviePlayerDelegate <NSObject>

@optional
-(void)OnEvent:(const int)code Contet:(NSString*)content;
-(void)OnRawVideo:(const char*)data Size:(int)size Width:(int)w Height:(int)h;
-(int)OnVideochange:(int)w Height:(int)h;
@end

#endif /* OpenCONSTS_h */
