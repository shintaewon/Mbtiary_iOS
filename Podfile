# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MBTIARY_Ver_1' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'FSCalendar'
pod 'KakaoSDK' 
pod 'MonthYearPicker'
pod 'Kingfisher'
pod 'Charts'
pod 'RxSwift'
  # Pods for MBTIARY_Ver_1

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'

	if target.name == "SwiftAlgorithms"
           config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'NO'
	end
      end
   end
end