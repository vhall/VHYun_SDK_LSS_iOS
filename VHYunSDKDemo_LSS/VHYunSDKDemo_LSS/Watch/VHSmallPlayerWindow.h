//
//  VHSmallPlayerWindow.h
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/8/23.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VHSmallPlayerWindowCloseEventHandler)(void);

@interface VHSmallPlayerWindow : UIWindow

/// 单例
+ (instancetype)sharedInstance;
/// 显示小窗
- (void)show;
/// 隐藏小窗
- (void)hide;

@property (nonatomic,copy) VHSmallPlayerWindowCloseEventHandler closeHandler;  //关闭

/// 小窗主view
@property (readonly) UIView *rootView;
/// 小窗是否显示
@property (readonly) BOOL isShowing;


@end

NS_ASSUME_NONNULL_END
