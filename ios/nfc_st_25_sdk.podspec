#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nfc_st_25_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nfc_st_25_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*.{h,m,swift}'
  s.dependency 'Flutter'
  s.platform = :ios, '14.1'

  s.frameworks = ['CoreNFC']

  s.vendored_frameworks = 'Frameworks/st25sdkFramework.framework'

  s.xcconfig = {
      'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/Frameworks/st25sdkFramework.framework/Headers/st25sdk/** $(PODS_TARGET_SRCROOT)/Frameworks/st25sdkFramework.framework/Headers/jre',
    }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    #'SWIFT_OBJC_BRIDGING_HEADER' => '$(PODS_TARGET_SRCROOT)/Classes/NfcSt25SdkPlugin-Bridging-Header.h',
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'nfc_st_25_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
