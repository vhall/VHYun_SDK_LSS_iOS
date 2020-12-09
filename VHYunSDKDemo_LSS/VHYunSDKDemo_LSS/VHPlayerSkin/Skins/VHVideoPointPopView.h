//
//  VHVideoPointPopView.h
//  VHYunSDKDemo_LSS
//
//  Created by xiongchao on 2020/11/2.
//  Copyright © 2020 vhall. All rights reserved.
//
//打点点击预览弹窗
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VHVidoePointModel;
@interface VHVideoPointPopView : UIView

//显示打点详情
+ (instancetype)showPointViewWithModel:(VHVidoePointModel *)model;

@end

NS_ASSUME_NONNULL_END
