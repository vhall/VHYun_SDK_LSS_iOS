//
//  VHVideoSubtitleView.h
//  VHLssVod
//
//  Created by xiongchao on 2020/11/6.
//  Copyright © 2020 vhall. All rights reserved.
//

//字幕view
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHVideoSubtitleView : UIView

- (void)setSubtitle:(NSString *)subTitle;

- (void)setSubtitleFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
