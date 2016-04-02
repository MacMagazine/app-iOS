source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

pod 'AFNetworking'
pod 'HockeySDK'
pod 'Ono', '1.2.2'
pod 'PureLayout'
pod 'SDWebImage'
pod 'SUNKit', :git => 'git@git.madeatsampa.com:madeatsampa/SUNKit.git' # :path => '~/Developer/made@sampa/SUNKit'
pod 'TOWebViewController', '~> 2.2'
pod 'Tweaks'
pod 'TTTAttributedLabel', '1.13.3'

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name == "Tweaks"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'FB_TWEAK_ENABLED=1']
            end
        end
    end
end