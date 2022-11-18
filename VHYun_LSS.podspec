Pod::Spec.new do |s|
  s.name      = "VHYun_LSS"
  s.version   = "2.7.4"
  s.summary   = "VHall iOS SDK #{s.name.to_s}"
  s.homepage  = 'https://www.vhall.com'
  s.author    = { "LiGuoliang" => "guoliang.li@vhall.com" }
  s.license   = { :type => "MIT", :file => "LICENSE" }
  s.source    = { :git => "https://github.com/vhall/VHYun_SDK_LSS_iOS.git", :tag => s.version.to_s}
  s.platform  = :ios, '9.0'
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**'
  }

  s.default_subspec = 'framework'
  s.subspec 'framework' do |ss|
    ss.vendored_frameworks = 'VHYunFrameworks/VhallLiveBaseApi.framework','VHYunFrameworks/VHLSS.xcframework'
  end

  s.subspec 'xcframework' do |ss|
    ss.vendored_frameworks = 'VHYunFrameworks/VhallLiveBaseApi.framework','VHYunFrameworks/VHLSS.xcframework'
  end


  s.dependency 'VHCore','>=2.3.1'
  
end