Pod::Spec.new do |s|
  s.name            = "VHYun_LSS_ScreenShare"
  s.version         = "2.3.20"
  s.author          = { "wangxiaoxiang" => "xiaoxiang.wang@vhall.com" }
  s.license         = { :type => "MIT", :file => "LICENSE" }
  s.homepage        = 'https://www.vhall.com'
  s.source          = { :git => "https://github.com/vhall/VHYun_SDK_LSS_iOS.git", :tag => s.version.to_s}
  s.summary         = "iOS LSS_ScreenShare framework"
  s.platform        = :ios, '12.0'
  s.requires_arc    = true
  #s.source_files    = ''
  s.frameworks      = 'Foundation'
  s.module_name     = 'VHYun_LSS_ScreenShare'
  s.resources       = ['README.md']
  #s.resource_bundles= {}
  s.vendored_frameworks = 'VHYunFrameworks/VHScreenShare.framework','VHYunFrameworks/VhallLiveBaseApi.framework'
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**'
  }
end
