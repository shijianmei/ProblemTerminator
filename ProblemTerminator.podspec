#
# Be sure to run `pod lib lint ProblemTerminator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ProblemTerminator'
  s.version          = '1.0.0'
  s.summary          = 'A short description of ProblemTerminator.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jianmei/ProblemTerminator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jianmei' => 'shijianmei0@sina.com' }
  s.source           = { :git => 'https://github.com/shijianmei/ProblemTerminator.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'ProblemTerminator/Classes/**/*'
  s.resources = ["ProblemTerminator/**/*.{xcassets,mg,storyboard,gif,png,jpg,mp3,MP4,mp4,zip,plist,acc,dat,bin,dms,html,js,a,webp,mov,json}"]

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.dependency 'MangoFix', '1.5.2'
end
