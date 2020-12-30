source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

workspace 'AnApp'

project 'AnApp/AnApp.xcodeproj'
project 'AnAppUIKit/AnAppUIKit.xcodeproj'
project 'AnAppKit/AnAppKit.xcodeproj'

def ui_pods
  pod 'Intercom'
  pod 'Firebase/Analytics'
end

def ui_kit_pods
  pod 'Cloudinary'
end 

def model_pods
  pod 'Alamofire'
end

target 'AnApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  project 'AnApp/AnApp.xcodeproj'
  ui_pods
end

target 'AnAppUIKit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  project 'AnAppUIKit/AnAppUIKit.xcodeproj'
  ui_kit_pods

  target 'AnAppUIKitTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'AnAppKit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  project 'AnAppKit/AnAppKit.xcodeproj'
  model_pods
end
