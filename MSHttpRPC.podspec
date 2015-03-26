#
# Be sure to run `pod lib lint MSHttpRPC.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MSHttpRPC"
  s.version          = "0.1.0"
  s.summary          = "MSHttpRPC是一个简单基于Http的RPC框架"
  s.description      = <<-DESC
                        MSHttpRPC是一个简单基于Http的RPC框架,完成了主体的HTTP-RPC的CS交互的工作，用户可通过注册相应的关键性的Block来完成自定义的功能。
                       DESC
  s.homepage         = "https://github.com/yishuiliunian/MSHttpRPC"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "stonedong" => "yishuiliunian@gmail.com" }
  s.source           = { :git => "https://github.com/yishuiliunian/MSHttpRPC.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MSHttpRPC' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'DZSinglonFactory'
  s.dependency 'CocoaLumberjack'
  s.dependency 'NSString-UrlEncode'
end
