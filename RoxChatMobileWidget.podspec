Pod::Spec.new do |s|
  s.name             = 'RoxChatMobileWidget'
  s.version          = '1.1.1'
  s.summary          = 'RoxChat mobile UI for client SDK iOS.'

  s.homepage         = 'https://roxchat/integration/mobile-sdk/ios-sdk-howto/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rox.Chat' => 'info@rox.chat' }
  s.source           = { :git => 'https://github.com/roxchat/mobile-widget-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version = '5.5'
  s.source_files = 'Sources/RoxChatMobileWidget/Classes/**/*.{swift,strings}'
  s.resources = 'Sources/RoxChatMobileWidget/Assets/**/*.{xib,strings}',
  'Sources/RoxChatMobileWidget/Assets/WidgetImages.xcassets'
  s.dependency 'RoxchatClientLibrary'
  s.dependency 'RoxChatKeyboard'
  s.dependency 'Cosmos', '~> 19.0.3'
  s.dependency 'Nuke', '~>  8.0'
  s.dependency 'FLAnimatedImage', '~> 1.0'
  s.dependency 'SnapKit'
end
