//
//  BottomOptionsController.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/5/10.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "BottomOptionsController.h"

@interface BottomOptionsController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (nonatomic) NSArray<OptItem *> *dataSource;
@property (nonatomic) NSString *titleString;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BottomOptionsController

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray<OptItem *> *)dataSource {
    if((self = [super initWithNibName:nil bundle:nil])) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.titleString = title;
        self.dataSource = dataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleString;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"OptionsCell" bundle:nil] forCellWithReuseIdentifier:@"OptionsCell"];
    [self.mainCollectionView selectItemAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (IBAction)onClickSure:(UIButton *)sender {
    if(self.handleOnClickSure) {
        self.handleOnClickSure(self.selectedIndexPath);
    }
    [self dismiss];
}
- (IBAction)onClickCancel:(UIButton *)sender {
    [self dismiss];
}
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}
- (void)showinViewController:(UIViewController *)vc {
    [vc presentViewController:self animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OptionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OptionsCell" forIndexPath:indexPath];
    cell.item = self.dataSource[indexPath.row];
    return cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].available;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataSource[indexPath.row].available==YES) {
        self.selectedIndexPath = indexPath;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGRectGetHeight(collectionView.bounds);
}

- (NSArray<OptItem *> *)dataSource {
    if(!_dataSource) {
        _dataSource = @[];
    }
    return _dataSource;
}

@end
