//
//  VHLivePublisher.h
//  VHLivePublisher
//
//  Created by vhall on 2017/11/15.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VHPublishConfig.h"
#import "IVHCapture.h"
#import "IVHBeautifyModule.h"

typedef NS_ENUM(NSInteger, VHStreamStatus) {
    VHStreamStatusStoped,//流状态
    VHStreamStatusStarting,
    VHStreamStatusPublishing,
    VHStreamStatusPasue,
};

@interface VHallPublisher : NSObject

@property (nonatomic,weak)id <VHallLivePublisherDelegate> delegate;

/**
 *  显示摄像头拍摄内容的View
 */
@property (nonatomic,strong,readonly)UIView * preView;

/**
 *  获取推流参数
 */
@property (nonatomic,strong,readonly)VHPublishConfig* config;

/**
 *  静音
 */
@property (nonatomic,assign)BOOL mute;

/// 静视
@property (nonatomic) BOOL cameraMute;

/**
 *  推流前可设置视频码率  取值范围 [100 - 1024]
 */
@property (nonatomic,assign)int videoBitRate;

/**
 *  推流状态
 */
@property (nonatomic,assign,readonly)BOOL isPublishing;

/**
 *  推流状态
 */
@property (nonatomic,assign,readonly)VHStreamStatus streamStatus;

/**
 *  前置还是后置
 */
@property (nonatomic,assign,readonly)AVCaptureDevicePosition captureDevicePosition;

/// 当前摄像头对焦位置
@property(nonatomic,assign,readonly) CGPoint focusPoint;

/**
 *  预览填充模式
 */
- (void)setContentMode:(VHVideoCaptureContentMode)contentMode;


- (id<IVHVideoCapture>)currentVideoCapture;


/**
 *  初始化
 *  @param config  config参数
 */
- (instancetype)initWithConfig:(VHPublishConfig*)config;

/// 初始化 自定义美颜功能
/// @param config config参数
/// @param module 自定义美颜工具
- (instancetype)initWithConfig:(VHPublishConfig*)config
                  AndvancedBeautify:(id<IVHBeautifyModule>)module;

/**
 *  初始化
 *  高级功能 自定义采集器
 *  @param config  config参数
 *  @param videoCapture  自定义视频采集器
 *  @param audioCapture  自定义音频采集器
 */
- (instancetype)initWithConfig:(VHPublishConfig*)config
                  videoCapture:(id<IVHVideoCapture>)videoCapture
                  audioCapture:(id<IVHAudioCapture>)audioCapture;
/**
 *  销毁初始化数据，同步销毁，如果感觉销毁太慢，可以开线程去销毁
 */
- (void)destoryObject;

/**
 *  开始采集数据 并预览
 */
- (BOOL)startCapture;

/**
 *  开始推流
 *  @param publishUrls 推流地址数组
 *  @param pushType  推流类型
 */
- (BOOL)startPublishUrls:(NSArray*)publishUrls pushType:(VHStreamType) pushType;
/**
 *  暂停推流 如电话接入、进入后台等
 */
- (BOOL)pause;

/**
 *  恢复推流
 */
- (BOOL)resume;

/**
 *  停止推流
 */
- (BOOL)stopPublish;

/**
 *  停止采集数据
 */
- (BOOL)stopCapture;

/**
 *  切换前后摄像头
 *  @param captureDevicePosition  后置:AVCaptureDevicePositionBack 前置:AVCaptureDevicePositionFront
 *  @return 是否切换成功
 */
- (BOOL)switchCamera:(AVCaptureDevicePosition)captureDevicePosition;

/**
 *  缩放摄像头
 *  @param zoomSize  变焦取值范围[1.0 - xx] xx 是系统相机支持最大变焦值
 */
- (BOOL)zoomCamera:(CGFloat)zoomSize;

/**
 *  镜像摄像头
 *  @param mirror YES:镜像 NO:不镜像
 */
- (void)camVidMirror:(BOOL)mirror;

/**
 *  手动对焦
 *  @param point 对焦点 [x,y] [0.0 - 1.0]
 *  @param focusMode 手动对焦完成后对焦模式
 */
- (BOOL)focusCameraAtAdjustedPoint:(CGPoint)point focusMode:(AVCaptureFocusMode)focusMode;

/**
 *  闪光灯开关 前置摄像头时无效
 *  @param captureTorchMode 闪光灯模式
 */
- (BOOL)torchMode:(AVCaptureTorchMode)captureTorchMode;

/**
 *  设置上报数据
 */
- (void)setLogParam:(NSString*)param;

// 打开噪声抑制 直播开始后有效
-(void)openNoiseSuppresion:(BOOL)enable;

/**
 设置音频增益大小，注意只有当开启噪音消除时可用
 
 @param size 音频增益的大小 [0.0,1.0]
 */
- (void)setVolumeAmplificateSize:(float)size;

/**
 *  曝光档数范围在minExposureTargetBias和maxExposureTargetBias之间。0为默认没有补偿0为默认没有补偿(注意每次调用对焦方法都会重置为0)
 */
- (void)setExposureTargetBias:(float)bias;

/**
 *  错误处理
 */
- (void)onError:(VHallPublishError)errorType errorInfo:(NSDictionary *)errorInfo;


/**
 *  设置软编码，默认为NO，录屏直播时，需要设置此值为YES，即设置为软编码 推流前有效
 */
- (void)enableForBacgroundEncode:(BOOL)enable;

/// 重新设置分辨率及其他主要采集参数
/// - Parameters:
///   - videoWidth: 宽
///   - videoHeight: 高
///   - videoBitRate: bit
///   - videoCaptureFPS: fps
- (void)updateVideoCaptureWidth:(int)videoWidth videoHeight:(int)videoHeight videoBitRate:(NSInteger)videoBitRate videoCaptureFPS:(NSInteger)videoCaptureFPS;
@end

