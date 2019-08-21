//
//  VHCustomPlayerSkinView.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHBaseSkinPlayerView.h"
#import "VHCstomResolutionView.h"
#import "VHCstomMoreView.h"
#import "UIView+Fade.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHCustomPlayerSkinView : VHBaseSkinPlayerView

//更多按钮
@property (nonatomic, strong) UIButton *moreBtn;
//弹幕按钮(暂无)
@property (nonatomic, strong) UIButton *danmakuBtn;

//分辨率view
@property (nonatomic, strong) VHCstomResolutionView *resolutionView;

//更多view
@property (nonatomic, strong) VHCstomMoreView *moreView;

//倍速view
@property (nonatomic, strong) VHSkinCoverView *rateView;


@end

NS_ASSUME_NONNULL_END
