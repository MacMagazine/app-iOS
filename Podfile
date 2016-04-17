source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'

target 'MacMagazine' do
    pod 'AFNetworking', '~> 3.1'
    pod 'HockeySDK', '~> 3.8'
    pod 'Ono', '~> 1.2'
    pod 'PureLayout', '~> 3.0'
    pod 'SDWebImage', '~> 3.7'
    pod 'ARChromeActivity', '~> 1.0'
    pod 'TUSafariActivity', '~> 1.0'
    pod 'Tweaks', '~> 2.0'
    pod 'TTTAttributedLabel', '~> 1.13'

    target 'MacMagazineTests' do
        pod 'Expecta', '~> 1.0'
        pod 'OCMock', '~> 3.2'
    end
end

plugin 'cocoapods-acknowledgements', settings_bundle: true

plugin 'cocoapods-keys', {
    :project => 'MacMagazine',
    :keys => [
        "MMMNotificationsAPIKey"
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
