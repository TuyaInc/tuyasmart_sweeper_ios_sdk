
Pod::Spec.new do |s|
    s.name             = 'TuyaSmartSweeperKit'
    s.version          = '0.1.7'
    s.summary          = 'A short description of TuyaSmartSweeperKit.'
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/TuyaInc/tuyasmart_sweeper_ios_sdk'
    s.license          = { :type => 'MIT' }
    s.author           = { 'huangdaxia' => 'huangkai@tuya.com' }
    s.source           = { :git => 'https://github.com/TuyaInc/tuyasmart_sweeper_ios_sdk.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.vendored_frameworks = 'ios/*.framework'
    
    s.dependency 'TuyaSmartDeviceKit', '~> 2.8.43'
end
