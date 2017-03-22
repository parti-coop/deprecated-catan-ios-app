# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'Catan' do
    # Comment this line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    project 'Catan', 'Debug-DevelopmentMaster' => :debug, 'Debug-DevelopmentDev' => :debug

  # Pods for Catan
    pod 'Bolts'
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    pod 'Alamofire', '~> 4.4'
    pod 'SwiftyJSON', '~> 3.1'
    pod 'KeychainAccess'
    pod 'SwiftyConfiguration'
    pod 'UIScrollView-InfiniteScroll'
    pod 'AlamofireObjectMapper', '~> 4.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
