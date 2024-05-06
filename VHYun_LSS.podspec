Pod::Spec.new do |s|
  s.name          = "VHYun_LSS"
  s.version       = "2.8.1"
  s.summary       = "VHall iOS SDK #{s.name.to_s}"
  s.homepage     = 'https://www.vhall.com'
  s.author       = { "GuoChao" => "chao.guo@vhall.com" }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.source          = { :git => "https://github.com/vhall/VHYun_SDK_LSS_iOS.git", :tag => s.version.to_s}
  s.requires_arc    = true
  s.platform        = :ios, '9.0'
  s.module_name     = "#{s.name.to_s}"
  s.vendored_frameworks = 'VHYunFrameworks/VhallLiveBaseApi.framework','VHYunFrameworks/VHLSS.framework'
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**'
  }
  s.dependency 'VHCore','>=2.3.7'
end