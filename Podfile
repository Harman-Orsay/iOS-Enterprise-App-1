source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

workspace 'AnApp'
use_frameworks!

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

  #the excutable target must include all dependencies from its included frameworks
  target 'AnApp' do
    project 'AnApp/AnApp.xcodeproj'
    ui_pods
    ui_kit_pods
    model_pods
  end

  target 'AnAppUIKit' do
    project 'AnAppUIKit/AnAppUIKit.xcodeproj'
    ui_kit_pods

    target 'AnAppUIKitTests' do
      inherit! :search_paths
      # Pods for testing
    end
  end

  target 'AnAppKit' do
    project 'AnAppKit/AnAppKit.xcodeproj'
    model_pods
    
    target 'AnAppKitTests' do
      inherit! :search_paths
      # Pods for testing
    end
  end
