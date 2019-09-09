//
//  VHCstomMoreView.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSkinCoverView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VHCstomMoreViewDelegate <NSObject>

@optional

- (void)cyclePlaySwitchOn:(BOOL)isOn;

@end

@interface VHCstomMoreView : VHSkinCoverView

- (instancetype)initWithFrame:(CGRect)frame isLive:(BOOL)live;

@property (nonatomic, weak) id <VHCstomMoreViewDelegate> delegate;

@property (nonatomic, strong) UISlider *soundSlider;

@property (nonatomic, strong) UISlider *lightSlider;

@end

NS_ASSUME_NONNULL_END
