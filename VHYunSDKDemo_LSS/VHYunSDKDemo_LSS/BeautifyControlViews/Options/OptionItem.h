//
//  OptionItem.h
//  VHYunSDKDemo_LSS
//
//  Created by 李国梁 on 2021/12/11.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    OptionStyleNone,
    OptionStyleSlider,
    OptionStyleSwitch,
    OptionStyleButton
} OptionStyle;

@interface OptionItem : NSObject

@property (nonatomic) NSString *title;      // 用于显示
@property (nonatomic) NSString *key;    // 用于设置Key
@property (nonatomic) OptionStyle style;    // option样式
@property (nonatomic) id currentValue;      // 当前值
@property (nonatomic) float minValue;       // 最小值
@property (nonatomic) float maxValue;       // 最大值

/// 不可选中
+ (instancetype)ItemNoneWithTitle:(NSString *)title;
/// 左title ，右value
+ (instancetype)ItemNextWithTitle:(NSString *)title key:(NSString *)key value:(NSString *)value;
/// 左title ，右Switch
+ (instancetype)ItemSwitchWithTitle:(NSString *)title key:(NSString *)key value:(BOOL)enable;
/// 左title ，右Slider
+ (instancetype)ItemSliderWithTitle:(NSString *)title key:(NSString *)key value:(float)value min:(float)min max:(float)max;
@end

NS_ASSUME_NONNULL_END
