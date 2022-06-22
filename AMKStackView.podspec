#
# Be sure to run `pod lib lint AMKStackView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

#
# Be sure to run `pod lib lint AMKStackView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'AMKStackView'
    s.version          = '1.0.0'
    s.summary          = 'Summary of AMKStackView.'
    s.description      = 'A description of AMKStackView.'
    s.homepage         = 'https://github.com/AndyM129/AMKStackView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andy Meng' => 'andy_m129@163.com' }
    s.source           = { :git => 'https://github.com/AndyM129/AMKStackView.git', :tag => s.version.to_s }
    s.social_media_url = 'https://juejin.cn/user/2875978147966855'
    s.ios.deployment_target = '8.0'
    s.source_files = 'AMKStackView/Classes/**/*.{h,m}'
    s.public_header_files = 'AMKStackView/Classes/**/*.h'
    s.frameworks = 'UIKit'
    s.dependency 'Masonry'
    s.dependency 'YYCategories'
end
