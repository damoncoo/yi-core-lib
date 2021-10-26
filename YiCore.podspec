# frozen_string_literal: true

#
# Be sure to run `pod lib lint YiCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YiCore'
  s.version          = '0.1.2'
  s.summary          = 'YiCore is a suite of tools for Yi app.'

  s.description      = <<-DESC
  YiCore is a suite of tools for Yi app.
  It is useful for all apps
  DESC

  s.homepage         = 'https://github.com/damoncoo/yi-core-lib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Damon Cheng' => 'damoncoo@gmail.com' }
  s.source           = { git: 'https://github.com/damoncoo/yi-core-lib.git', tag: s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'YiCore/Sources/**/*'

  # s.resource_bundles = {
  #   'YiCore' => ['YiCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'QuartzCore', 'UIKit'
  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'PromiseKit', '~> 6.8'
  s.dependency 'RxSwift', '~> 5.1.1'
  s.dependency 'RxCocoa', '~> 5.1.1'
  s.dependency 'Kingfisher'
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'Alamofire', '~> 5.4.4'
  s.dependency 'SwCrypt'
  s.dependency 'SwiftyRSA'
  s.dependency 'Qiniu', '~> 8.1.0'
  s.dependency 'Swifter', '~> 1.5.0'
  s.dependency 'CRRefresh', '~> 1.1.3'
  s.dependency 'SwifterSwift'
  s.dependency 'SwiftDate', '~> 6.2.0'
  s.dependency 'ADPhotoKit', '1.1.3'
end
