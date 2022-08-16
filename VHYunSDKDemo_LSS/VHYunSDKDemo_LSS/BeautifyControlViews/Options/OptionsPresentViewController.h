//
//  OptionsPresentViewController.h
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2021/12/10.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionRowCell.h"
#import <VHBeautifyKit/VHBeautifyKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OPButton : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) void(^handleOnClicked)(UIButton *button);
+ (instancetype)createWithTitle:(NSString *)title handle:(void(^)(UIButton *button))handle;
@end

@interface OptionsPresentViewController : UIViewController
@property (nonatomic) OptionsPresentViewController *preoption;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) VHBeautifyKit *beautifykit;
@property (nonatomic) NSArray<OPButton *> *opbuttons;
@property (nonatomic) NSArray<OptionItem *> *datas;
@property (nonatomic) void(^handleWillChangeSize)(CGSize size);
- (void)registCellNibName:(UINib *)cellnib;
- (void)updateEffectForItem:(OptionItem *)item;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
