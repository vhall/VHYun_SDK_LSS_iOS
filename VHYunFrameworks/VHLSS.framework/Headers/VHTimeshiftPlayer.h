//
//  VHTimeshiftPlayer.h
//  VHLive
//
//  Created by 郭超 on 2021/8/16.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VHPlayerTypeDef.h"
#import "VHPlayerCommonModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol VHTimeshiftPlayerDelegate;

@interface VHTimeshiftPlayer : NSObject
- (instancetype)initWithLogParam:(NSDictionary*)logParam;
@property (nonatomic,weak) id <VHTimeshiftPlayerDelegate>      delegate;
/**
 * 播放器view
 */
@property (nonatomic,strong,readonly) UIView             *view;
/**
 * 播放器状态  详见 VHPlayerStatus 的定义.
 */
@property (nonatomic,assign,readonly) VHPlayerStatus     playerState;
/**
 *  设置默认播放的清晰度 默认原画
 */
@property(nonatomic,assign)VHDefinition             defaultDefinition;

/**
 * 当前播放的清晰度 默认原画 只有在播放开始后调用 并在支持的清晰度列表中
 */
@property(nonatomic,assign)VHDefinition             curDefinition;
/**
 * 是否静音
 */
@property(nonatomic,assign) BOOL mute;
/**
 * 水印 ImageView 设置水印图片 及显示位置  注：只要使用了该属性 PaaS 控制台设置图片方式便失效
 */
@property (nonatomic,readonly) UIImageView* watermarkImageView;

/**
 * 使用直播时移 当前播放时长 (直播时移才生效)
 */
@property(nonatomic, assign) NSInteger live_duration;

/**
 *  直播时移播放
 *  @param roomId         房间ID
 *  @param delay          时移默认90秒之前的音视频内容  90以内为直播服务
 *  @param accessToken  accessToken
 */
- (BOOL)startLivePlay:(NSString*)roomID delay:(NSInteger)delay accessToken:(NSString*)accessToken;
/**
 *  暂停播放
 */
- (BOOL)pause;

/**
 *  恢复播放
 */
- (BOOL)resume;

/**
 *  结束播放
 */
- (BOOL)stopPlay;

/**
 *  销毁播放器，销毁播放器后需将VHVodPlayer对象制为nil。
 */
- (BOOL)destroyPlayer;

/**
 *  获得当前SDK版本号
 */
+ (NSString *) getSDKVersion;

@end

@protocol VHTimeshiftPlayerDelegate <NSObject>

@optional
/**
 *  观看状态回调
 *  @param player   播放器实例
 *  @param state   状态类型
 */
- (void)player:(VHTimeshiftPlayer *)player statusDidChange:(VHPlayerStatus)state;

/**
 *  当前点播支持的清晰度列表
 *  @param definitions   支持的清晰度列表
 *  @param definition    当前播放清晰度
 */
- (void)player:(VHTimeshiftPlayer *)player validDefinitions:(NSArray*)definitions curDefinition:(VHDefinition)definition;

/**
 *  错误回调
 *  @param player   播放器实例
 *  @param error    错误
 */
- (void)player:(VHTimeshiftPlayer *)player stoppedWithError:(NSError *)error;

/**
 *  当前播放器时间回调
 *  @param player   播放器实例
 *  @param currentTime    当前播放器时间回调
 */
- (void)player:(VHTimeshiftPlayer*)player currentTime:(NSTimeInterval)currentTime;

/**
 *  当前播放器 有文档回放
 *  @param player   播放器实例
 *  @param docChannels 文档channelID 列表
 */
- (void)player:(VHTimeshiftPlayer*)player docChannels:(NSArray*)docChannels;

/**
 *  视频宽髙回调
 *  @param player   播放器实例
 *  @param size    当前播放视频宽髙
 */
- (void)player:(VHTimeshiftPlayer*)player videoSize:(CGSize)size;


#pragma mark - 打点

/// 返回视频打点数据（若存在打点信息）
/// @param player 播放器实例
/// @param pointArr 已打点的数据
- (void)player:(VHTimeshiftPlayer *)player videoPointArr:(NSArray <VHVidoePointModel *> *)pointArr;



#pragma mark - 字幕

/// 当前视频所支持的字幕列表
/// @param player 播放器实例
/// @param subTitleArr 当前视频支持的字幕数组（若无字幕，则返回空）
- (void)player:(VHTimeshiftPlayer *)player videoSubtitleArr:(NSArray <VHVidoeSubtitleModel *> *)subTitleArr;

@end

NS_ASSUME_NONNULL_END
