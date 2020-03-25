# Uncomment the next line to define a global platform for your project
platform :ios, '12.2'

target 'Rubi' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'ReachabilitySwift', '4.3.1'
  pod 'lottie-ios', '3.1.6'
  pod 'SwiftyTesseract', '2.1.0'
  pod 'Sketch', '3.0'

  # Pods for Rubi

  target 'RubiTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RubiUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if 'SwiftyTesseract'.include? target.name
                config.build_settings['SWIFT_VERSION'] = "4.2"
            else
                config.build_settings['SWIFT_VERSION'] = "5.0"
            end
        end
    end
end