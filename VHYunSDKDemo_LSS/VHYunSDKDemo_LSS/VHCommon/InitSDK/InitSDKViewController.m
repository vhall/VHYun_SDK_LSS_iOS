//
//  InitSDKViewController.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "InitSDKViewController.h"
#import <objc/message.h>
#import "UIView+ITTAdditions.h"

@interface InitSDKViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *bundleIDLabel;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *avatarTextField;
@end

@implementation InitSDKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    
}

- (void)viewDidLayoutSubviews
{
    [self.view viewWithTag:10099].top = _userIDTextField.bottom-2;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initView {
    [VHLiveBase setAppGroup:VHSystemInstance.groupID];
    _appIDTextField.text = VHSystemInstance.appID;
    _userIDTextField.text = VHSystemInstance.third_party_user_id;
    _nicknameTextField.text = VHSystemInstance.nickName;
    _avatarTextField.text = VHSystemInstance.avatar;
    _bundleIDLabel.text = [NSBundle mainBundle].bundleIdentifier;
}

- (IBAction)nextBtnClicked:(id)sender {
    [self hideKeyBoard];

    VHSystemInstance.appID = _appIDTextField.text;
    VHSystemInstance.third_party_user_id =_userIDTextField.text;
    
    if(VHSystemInstance.appID.length<=0)
    {
        [self showMsg:@"appID 不能为空" afterDelay:1];
        return;
    }
    if(VHSystemInstance.third_party_user_id.length<=0)
    {
        [self showMsg:@"用户ID 不能为空" afterDelay:1];
        return;
    }
    VHSystemInstance.nickName = _nicknameTextField.text;
    VHSystemInstance.avatar   = _avatarTextField.text;
    [VHLiveBase registerApp:VHSystemInstance.appID host:@"" completeBlock:^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [VHLiveBase setThirdPartyUserId:VHSystemInstance.third_party_user_id context:@{@"nick_name":VHSystemInstance.nickName,@"avatar":VHSystemInstance.avatar}];
}

- (void)hideKeyBoard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
