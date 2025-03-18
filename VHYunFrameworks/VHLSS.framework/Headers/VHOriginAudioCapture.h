//
//  VHOriginCapture.h
//  VHLssPublisher
//
//  Created by vhall on 2017/11/21.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IVHCapture.h"

@interface VHOriginAudioCapture : NSObject <IVHAudioCapture>

@property (nonatomic,assign)VHCaptureStatus captureStatus;

@property (nonatomic,copy)OutputSampleBufferBlock outputSampleBufferBlock;
@property (nonatomic,copy)OutputDataBufferBlock outputDataBufferBlock;
@property (nonatomic,copy)OnErrorBlock errorBlock;

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

@end
