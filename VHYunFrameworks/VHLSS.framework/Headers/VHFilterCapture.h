//
//  VHFilterCapture.h
//  VHLssPublisher
//
//  Created by vhall on 2017/11/21.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IVHCapture.h"

@interface VHFilterCapture : NSObject <IVHVideoCapture>

@property (nonatomic,assign)VHCaptureStatus captureStatus;

@property (nonatomic,copy)OutputSampleBufferBlock outputSampleBufferBlock;
@property (nonatomic,copy)OnErrorBlock errorBlock;

/**
 *  美颜
 */
@property (nonatomic,assign)BOOL enableFilter;

/**
 *  配置采集器
 *  @param config 配置参数
 */
- (BOOL) setConfig:(VHPublishConfig*)config;

/**
 *  设置数据回调
 *  @param block 采集到的数据通过block回调给VHLivePublisher
 */
- (void) setOutputSampleBufferBlock:(OutputSampleBufferBlock)block;

/**
 *  设置错误回调
 *  @param block 错误信息
 */
- (void) setErrorBlock:(OnErrorBlock)block;

/**
 *  开始采集数据
 */
- (BOOL) startCapture;

/**
 *  结束采集数据
 */
- (BOOL) stopCapture;

/**
 *  获取采集器状态
 */
- (VHCaptureStatus) getStatus;

/**
 *  释放采集器资源
 */
- (BOOL)destoryObject;

/////////////////////////////////////////////////////////////////////

- (void)setFilterBilateral:(CGFloat)distanceNormalizationFactor Brightness:(CGFloat)brightness Saturation:(CGFloat)saturation Sharpness:(CGFloat)sharpness;

/**
 *  曝光档数范围在minExposureTargetBias和maxExposureTargetBias之间。0为默认没有补偿0为默认没有补偿(注意每次调用对焦方法都会重置为0)
 */
- (void)setExposureTargetBias:(float)bias;

/**
 *  显示摄像头拍摄内容的View
 */
@property (nonatomic,strong,readonly)UIView * preView;

/**
 *  判断用户使用是前置还是后置摄像头
 */
@property (nonatomic,assign,readonly)AVCaptureDevicePosition captureDevicePosition;

/**
 *  切换摄像头
 *  @param captureDevicePosition  后置:AVCaptureDevicePositionBack 前置:AVCaptureDevicePositionFront
 *  @return 是否切换成功
 */
- (BOOL)switchCamera:(AVCaptureDevicePosition)captureDevicePosition;//切换前后摄像头
- (BOOL)zoomCamera:(CGFloat)zoomSize;   // 缩放摄像头
- (BOOL)focusCameraAtAdjustedPoint:(CGPoint)point focusMode:(AVCaptureFocusMode)focusMode;//手动对焦 对焦完成后变为自动对焦
- (BOOL)torchMode:(AVCaptureTorchMode)captureTorchMode;//前置摄像头无效

/**
 *  镜像摄像头
 *  @param mirror YES:镜像 NO:不镜像
 */
- (void)camVidMirror:(BOOL)mirror;
@end
