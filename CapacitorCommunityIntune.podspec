require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'CapacitorCommunityIntune'
  s.version = package['version']
  s.summary = package['description']
  s.license = 'MIT'
  s.homepage = 'https://github.com/capacitor-community/intune'
  s.author = 'Capacitor Community'
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.source_files = 'ios/Sources/IntunePlugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target = '17.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
  s.ios.vendored_frameworks = 'ios/IntuneMAMSwift.xcframework', 'ios/IntuneMAMSwiftStub.xcframework'
  s.dependency 'MSAL', '~> 1.9.0'
end
