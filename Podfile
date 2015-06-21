platform :ios, '8.0'

source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!

pod 'AFNetworking', '2.5.4'
pod 'HockeySDK', '3.6.4'
pod 'Ono', '1.2.2'
pod 'PSTAlertController', '1.1.0'
pod 'PureLayout', '2.0.6'
pod 'SUNKit', :git => 'git@git.madeatsampa.com:madeatsampa/SUNKit.git' # :path => '~/Developer/made@sampa/SUNKit'
pod 'Tweaks', '2.0.0'
pod 'TSMessages', '0.9.12'
pod 'TTTAttributedLabel', '1.13.3'

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        if target.name == "Pods-Tweaks"
            target.build_configurations.each do |config|
                if config.name == 'Release'
                    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'FB_TWEAK_ENABLED=1']
                end
            end
        end
    end
end
