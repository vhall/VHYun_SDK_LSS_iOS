//
//  OptionItem.m
//  VHYunSDKDemo_LSS
//
//  Created by 李国梁 on 2021/12/11.
//  Copyright © 2021 vhall. All rights reserved.
//

#import "OptionItem.h"


//typedef enum : NSUInteger {
//    OptionStyleNone,
//    OptionStyleSlider,
//    OptionStyleSwitch,
//    OptionStyleButton
//} OptionStyle;


@implementation OptionItem
+ (instancetype)OptionItemTitle:(NSString *)title key:(NSString *)key style:(OptionStyle)style min:(float)min  currentValue:(id)value max:(float)max {
    OptionItem * item = [OptionItem new];
    item.title = title;
    item.key = key;
    item.style = style;
    item.minValue = min;
    item.maxValue = max;
    item.currentValue = value;
    return item;
}

+ (instancetype)ItemNoneWithTitle:(NSString *)title {
    return [self OptionItemTitle:title key:nil style:OptionStyleNone min:0 currentValue:nil max:0];
}
+ (instancetype)ItemNextWithTitle:(NSString *)title key:(NSString *)key value:(NSString *)value {
    return [self OptionItemTitle:title key:key style:OptionStyleButton min:0 currentValue:value max:0];
}
+ (instancetype)ItemSwitchWithTitle:(NSString *)title key:(NSString *)key value:(BOOL)enable {
    return [self OptionItemTitle:title key:key style:OptionStyleSwitch min:0 currentValue:@(enable) max:0];
}
+ (instancetype)ItemSliderWithTitle:(NSString *)title key:(NSString *)key value:(float)value min:(float)min max:(float)max {
    return [self OptionItemTitle:title key:key style:OptionStyleSlider min:min currentValue:@(value) max:max];
}

@end
