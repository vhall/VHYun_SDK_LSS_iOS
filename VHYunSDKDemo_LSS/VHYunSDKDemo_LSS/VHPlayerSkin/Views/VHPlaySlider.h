//
//  VHPlaySlider.h
//  VHPlayerSkin
//
//  Created by vhall on 2019/7/29.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VHPlaySlider;

@protocol VHPlaySliderDelegate <NSObject>

@optional

- (void)sliderTouchBegan:(VHPlaySlider *)slider;
- (void)sliderValueChanged:(VHPlaySlider *)slider;
- (void)sliderTouchEnded:(VHPlaySlider *)slider;
- (void)sliderSignleTouch:(VHPlaySlider *)slider;

@end


@interface VHPlaySlider : UISlider

@property (nonatomic, weak) id <VHPlaySliderDelegate> delegate;

@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, strong) UIProgressView *progressView;

@end

NS_ASSUME_NONNULL_END
