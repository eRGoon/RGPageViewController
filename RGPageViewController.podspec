Pod::Spec.new do |s|
  s.name = 'RGPageViewController'
  s.version = '1.0.0'
  s.summary = 'A custom UIPageViewController inspired by the ViewPager known from Android.'
  s.description  = <<-DESC
                    RGPageViewController is a custom UIPageViewController written in Swift. It is inspired by [ICViewPager](https://github.com/iltercengiz/ICViewPager "ICViewPager") by Ilter Cengiz but with some modifications. It combines an Android-like ViewPager with the blur effect introduced in iOS7. It is fully customizable and can also be used as a replacement for UITabBar.
                   DESC
  s.homepage = 'https://github.com/eRGoon/RGPageViewController'
  s.license = 'MIT'
  s.author = { 'Ronny Gerasch' => 'rg@ergoon.com' }
  
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  
  s.source = { :git => 'https://github.com/eRGoon/RGPageViewController.git', :tag => s.version }
  s.source_files  = 'RGPageViewController/RGPageViewController', 'RGPageViewController/RGPageViewController/**/*.{h,m,swift}'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
