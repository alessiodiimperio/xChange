# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'xChange' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
  # Pods for xChange

	pod 'Swinject'
	pod 'SwinjectStoryboard'

	pod 'RxSwift'
	pod 'RxCocoa'
  pod 'RxGesture'
  
  pod 'SnapKit', '~> 5.0.0'
  
  pod 'Alamofire', '~> 5.2'
  pod 'AlamofireImage', '~> 4.1'

	pod 'Firebase/Analytics'
	pod 'Firebase/Firestore'
	pod 'Firebase/Auth'
	pod 'Firebase/Storage'
	pod 'FirebaseFirestoreSwift', '~> 7.0-beta'
  
  pod 'IQKeyboardManagerSwift'

  target 'xChangeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'xChangeUITests' do
    # Pods for testing
  end

end
