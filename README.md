# VHYun_SDK_LSS_iOS
微吼云 直播、点播 iOS SDK 及 Demo<br>


集成和调用方式，参见官方文档：http://www.vhallyun.com/docs/show/22.html <br>

组合 Demo https://github.com/vhall/VHYun_SDK_iOS <br>

### SDK 两种引入方式
1、pod 'VHYun_LSS','~> 2.1.0' 注意查看Framework路径是否设置成功<br>
2、手动下载拖入工程设置路径、Embed&Sign<br>
注意依赖 https://github.com/vhall/VHYun_SDK_Core_iOS.git VHCore库<br>


### APP工程集成SDK基本设置
1、关闭bitcode 设置<br>
2、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
3、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
4、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
5、plist中添加相机、麦克风权限 <br>



### 版本更新信息
#### 版本 v2.1.1 更新时间：2019.04.10
更新内容：<br>
1、直播库优化<br>

#### 版本 v2.1.0 更新时间：2019.03.12
更新内容：<br>
1、新增白平衡功能<br>
2、码率自适应<br>

#### 版本 v2.0.1 更新时间：2019.09.09
更新内容：<br>
1、播放器皮肤<br>

#### 版本 v2.0.0 更新时间：2019.08.21
更新内容：<br>
1、美颜性能优化<br>
2、demo优化<br>

