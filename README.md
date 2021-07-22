# VHYun_SDK_LSS_iOS
微吼云 直播、点播 iOS SDK 及 Demo<br>


集成和调用方式，参见官方文档：http://www.vhallyun.com/docs/show/22.html <br>

组合 Demo https://github.com/vhall/VHYun_SDK_iOS <br>

### SDK 两种引入方式
1、pod 'VHYun_LSS' 注意查看Framework路径是否设置成功<br>
2、手动下载拖入工程设置路径、Embed&Sign<br>
注意依赖 https://github.com/vhall/VHYun_SDK_Core_iOS.git VHCore库<br>


### APP工程集成SDK基本设置
1、关闭bitcode 设置<br>
2、plist 中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES<br>
3、注册`AppKey`  [VHLiveBase registerApp:`AppKey`]; <br>
4、检查工程 `Bundle ID` 是否与`AppKey`对应 <br>
5、plist中添加相机、麦克风权限 <br>



### 版本更新信息
#### 版本 v2.3.3 更新时间：2021.07.22
更新内容：<br>
1、优化日志上报<br>

#### 版本 v2.3.2 更新时间：2021.05.31
更新内容：<br>
1、新增RTMP实时字幕<br>
2、日志上报优化<br>
3、修复点播调用暂停失效的bug<br>

#### 版本 v2.3.1 更新时间：2021.03.08
更新内容：<br>
1、播放器优化<br>

#### 版本 v2.3.0 更新时间：2020.12.09
更新内容：<br>
1、新增点播打点数据回调<br>
2、新增点播字幕功能<br>
3、支持视频投屏<br>

#### 版本 v2.2.0 更新时间：2020.06.11
更新内容：<br>
1、解决后台播放切前台偶现卡顿问题<br>

#### 版本 v2.1.3 更新时间：2020.05.21
更新内容：<br>
1、支持1080p推流<br>
2、新增观看视频宽髙回调<br>
3、新增点播静音功能<br>

#### 版本 v2.1.1 更新时间：2020.04.10
更新内容：<br>
1、直播库优化<br>

#### 版本 v2.1.0 更新时间：2020.03.12
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

