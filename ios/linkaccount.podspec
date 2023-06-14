#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint linkaccount.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'linkaccount'
  s.version          = '1.0.2'
  s.summary          = 'Flutter 一键登录插件'
  s.description      = <<-DESC
Flutter 一键登录插件
                       DESC
  s.homepage         = 'https://www.linkedme.cc'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LinkedME' => 'support@linkedme.cc' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'LinkedME_LinkAccount'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
