platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

pod 'AFNetworking'
pod 'HockeySDK'
pod 'Ono', '1.2.2'
pod 'PSTAlertController', '1.1.0'
pod 'PureLayout'
pod 'SDWebImage/WebP', '3.7.2'
pod 'SUNKit', :git => 'git@git.madeatsampa.com:madeatsampa/SUNKit.git' # :path => '~/Developer/made@sampa/SUNKit'
pod 'Tweaks'
pod 'TSMessages', '0.9.12'
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