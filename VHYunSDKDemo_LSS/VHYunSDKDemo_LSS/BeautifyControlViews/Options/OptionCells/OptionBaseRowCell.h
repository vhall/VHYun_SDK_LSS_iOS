//
//  OptionBaseRowCell.h
//  VHYunSDKDemo_LSS
//
//  Created by 李国梁 on 2021/12/11.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OptionBaseRowCell : UITableViewCell
@property (nonatomic) void(^handleOnChangeValue)(OptionItem *item);
@property (nonatomic) OptionItem *item;
@end

NS_ASSUME_NONNULL_END
