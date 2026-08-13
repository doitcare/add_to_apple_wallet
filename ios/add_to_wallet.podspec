Pod::Spec.new do |s|
  s.name             = 'add_to_wallet'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin interacting with Apple Wallet.'
  s.description      = <<-DESC
Flutter plugin exposing native PKAddPassButton to interact with the Apple Wallet
                       DESC
  s.homepage         = 'https://github.com/barkibu/add_to_wallet'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Barkibu' => 'leo@barkibu.com' }
  s.source           = { :path => '.' }
  # Combine the add_to_wallet and add_to_wallet_objc sources into a single pod,
  # unlike SwiftPM, where separate Swift and Objective-C targets are required.
  s.source_files = 'add_to_wallet/Sources/add_to_wallet*/**/*.{h,m,swift}'
  s.public_header_files = 'add_to_wallet/Sources/add_to_wallet_objc/include/**/*.h'
  s.resource_bundles = { 'add_to_wallet_privacy' => ['add_to_wallet/Sources/add_to_wallet/Resources/PrivacyInfo.xcprivacy'] }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.xcconfig = {
    'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)/ $(SDKROOT)/usr/lib/swift',
    'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift',
  }
  s.swift_version = '5.0'
end
