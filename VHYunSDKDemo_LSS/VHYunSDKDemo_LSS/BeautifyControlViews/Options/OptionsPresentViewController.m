//
//  OptionsPresentViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2021/12/10.
//  Copyright © 2021 vhall. All rights reserved.
//

#import "OptionsPresentViewController.h"
#import "OptionCells/OptionRowCell.h"
#import <VHBFURender/VHBeautifyEffectList.h>



@implementation OPButton

+ (instancetype)createWithTitle:(NSString *)title handle:(void(^)(UIButton *button))handle {
    OPButton *button = [[OPButton alloc] init];
    button.title = title;
    button.handleOnClicked = handle;
    return button;
}

@end

@interface OptionsPresentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btn_Left;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (weak, nonatomic) IBOutlet UITableView *optionTableView;
@property (nonatomic) UINib *cellNib;
@property (nonatomic) OptionItem *choosedItem;
@end

@implementation OptionsPresentViewController

- (instancetype)init {
    if((self = [super init])) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btn_Left setTitle:self.opbuttons.firstObject.title forState:UIControlStateNormal];
    [self.btn_right setTitle:self.opbuttons.lastObject.title forState:UIControlStateNormal];
    self.optionTableView.delegate = self;
    self.optionTableView.dataSource = self;
    self.optionTableView.tableFooterView = [UIView new];
    [self.optionTableView registerNib:self.cellNib forCellReuseIdentifier:@"CELL"];
    [self setupBackgorundEvent];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.handleWillChangeSize){
        self.handleWillChangeSize(self.optionTableView.bounds.size);
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    if(self.handleWillChangeSize){
        self.handleWillChangeSize(CGSizeZero);
    }
}
- (void)setupBackgorundEvent {
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBgView)];
    [bgView addGestureRecognizer:tap];
    [self.view sendSubviewToBack:bgView];
}
- (void)onTapBgView {
    [self dismiss];
}
/// 更新美颜设置数值
- (void)updateEffectForItem:(OptionItem *)item {
    if(item.style == OptionStyleButton) {
        self.choosedItem.currentValue = item.currentValue;
        [self.optionTableView reloadData];
    }
    [self.beautifykit setEffectKey:item.key toValue:item.currentValue];
}
- (void)dismiss {
    if(self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickLeftButton:(UIButton *)sender {
    if(self.opbuttons.firstObject.handleOnClicked) {
        self.opbuttons.firstObject.handleOnClicked(sender);
    }
}
- (IBAction)onClickRightButton:(UIButton *)sender {
    if(self.opbuttons.lastObject.handleOnClicked) {
        self.opbuttons.lastObject.handleOnClicked(sender);
    }
}

- (void)registCellNibName:(UINib *)cellnib {
    self.cellNib = cellnib;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OptionRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    cell.item = self.datas[indexPath.row];
    cell.selectionStyle = cell.item.style == OptionStyleButton ? UITableViewCellSelectionStyleDefault :  UITableViewCellSelectionStyleNone;
    __weak typeof(self) wself = self;
    cell.handleOnChangeValue = ^(OptionItem * _Nonnull item) {
        __strong typeof(wself) self = wself;
        switch (item.style) {
            case OptionStyleSwitch:
                if([item.key isEqualToString:@"VHBeautifyEnableOption"]) {
                    [self.beautifykit setEnable:[item.currentValue boolValue]];
                }
                break;
            case OptionStyleButton:
                if(self.preoption==nil){
                    [self showSelectListWithItem:item];
                }else{
                    [self.preoption updateEffectForItem:self.datas[indexPath.row]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismiss];
                    });
                }
                break;
            case OptionStyleSlider:
                [self updateEffectForItem:item];
                break;
            default:
                break;
        }
    };
    return cell;
}

- (void)showSelectListWithItem:(OptionItem *)item {
    self.choosedItem = item;
    OptionsPresentViewController *subOption = [[OptionsPresentViewController alloc] init];
    subOption.beautifykit = self.beautifykit;
    NSMutableArray *arr = [NSMutableArray array];
    for(NSString *filtername in [VHBeautifyEffectList filterListWithFU]) {
        [arr addObject:[OptionItem ItemNextWithTitle:nil key:eff_key_FU_FilterName value:filtername]];
    }
    subOption.datas = arr;
    [subOption registCellNibName:[UINib nibWithNibName:@"OptionRowCell" bundle:nil]];
    subOption.preoption = self;
    [self presentViewController:subOption animated:YES completion:nil];
}
@end
