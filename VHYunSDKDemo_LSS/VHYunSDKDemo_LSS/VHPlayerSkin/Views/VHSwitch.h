//
//  VHSwitch.h
//  VHPlayerSkin
//
//  Created by vhall on 2019/7/30.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VHSwitch;

@protocol VHSwitchDelegate <NSObject>

- (void)switchOn:(VHSwitch *)sender isOn:(BOOL)on;

@end

@interface VHSwitch : UISwitch

@property (nonatomic, weak) id <VHSwitchDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
