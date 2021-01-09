
Pod::Spec.new do |s|
    s.name             = 'TuyaSmartSweeperKit'
    s.version          = '2.0.0'
    s.summary          = 'A short description of TuyaSmartSweeperKit.'
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/TuyaInc/tuyasmart_sweeper_ios_sdk'
    s.license          = { :type => 'MIT' }
    s.authors          = { 'TuyaInc' => 'https://www.tuya.com' }
    s.source           = { :http => "https://airtake-public-data-1254153901.cos.ap-shanghai.myqcloud.com/smart/app/package/sdk/ios/#{s.name}-#{s.version}.zip", :type => "zip" }
    s.static_framework = true
    s.ios.deployment_target = '9.0'
    s.ios.vendored_framework = 'ios/*.framework'

    s.dependency 'TuyaSmartDeviceKit'
end
