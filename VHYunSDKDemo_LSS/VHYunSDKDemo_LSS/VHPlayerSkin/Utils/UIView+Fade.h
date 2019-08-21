//
//  UIView+Fade.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Fade)

- (UIView *)fadeShow;
- (void)fadeOut:(NSTimeInterval)delay;
- (void)cancelFadeOut;

@end

NS_ASSUME_NONNULL_END
