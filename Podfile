source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

target 'MacMagazineNotificationServiceExtension' do
	pod 'OneSignal', '>= 2.6.2', '< 3.0'
end

target 'MacMagazine' do
    pod 'AFNetworking', '~> 3.1'
    pod 'ARChromeActivity', '~> 1.0'
    pod 'Crashlytics', '~> 3.8'
    pod 'HockeySDK', '~> 4.1'
    pod 'Ono', '~> 1.2'
    pod 'PureLayout', '~> 3.0'
    pod 'SDWebImage', '~> 3.7'
    pod 'TSMessages', '~> 0.9'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'Tweaks', '~> 2.0'
	pod 'OneSignal', '>= 2.6.2', '< 3.0'

	target 'MacMagazineTests' do
        inherit! :search_paths
        
        pod 'Expecta', '~> 1.0'
        pod 'OCMock', '~> 3.3'
    end
end

plugin 'cocoapods-acknowledgements', settings_bundle: true

plugin 'cocoapods-keys', {
    :project => 'MacMagazine',
    :keys => [
        'MMMCrashlyticsAPIKey',
        'MMMNotificationsAPIKey'
    ]
}

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        if target.name == "Tweaks"
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'FB_TWEAK_ENABLED=1']
            end
        end
    end
end
