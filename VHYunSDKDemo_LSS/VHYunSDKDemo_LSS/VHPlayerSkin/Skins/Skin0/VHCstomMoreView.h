//
//  VHCstomMoreView.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSkinCoverView.h"
#import <VHLSS/VHPlayerCommonModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VHCstomMoreViewDelegate <NSObject>

@optional

//是否循环播放
- (void)cyclePlaySwitchOn:(BOOL)isOn;

//是否显示打点
- (void)showPointSwitchOn:(BOOL)isOn;

//显示字幕
- (void)showSubtitle:(BOOL)open completion:(void(^_Nullable)(VHVidoeSubtitleModel *_Nullable subtitle))completion;

//选择字幕
- (void)selelectSubtitle:(VHVidoeSubtitleModel *_Nullable)subtitle;

@end

@interface VHCstomMoreView : VHSkinCoverView

- (instancetype)initWithFrame:(CGRect)frame isLive:(BOOL)live;

@property (nonatomic, weak) id <VHCstomMoreViewDelegate> delegate;

@property (nonatomic, strong) UISlider *soundSlider;

@property (nonatomic, strong) UISlider *lightSlider;

//设置字幕列表
- (void)setSubtitleArr:(NSArray <VHVidoeSubtitleModel *> *)array;

@end

NS_ASSUME_NONNULL_END
