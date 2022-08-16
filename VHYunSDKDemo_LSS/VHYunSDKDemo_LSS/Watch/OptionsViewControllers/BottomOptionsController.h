//
//  BottomOptionsController.h
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/5/10.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsCell.h"

@interface BottomOptionsController : UIViewController
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) void(^handleOnClickSure)(NSIndexPath *indexPath);
- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray<OptItem *> *)dataSource;
- (void)showinViewController:(UIViewController *)vc;
@end
