
Pod::Spec.new do |s|
  s.name = 'CorePlayer'
  s.version = '1.7.1'
  s.license = 'MIT'
  s.summary = 'A iOS and OSX media player framework based on AVPlayer.'
  s.homepage = 'https://github.com/flexih/CorePlayer.Swift'
  s.authors = { 'flexih' => 'flexih.pods@gmail.com' }
  s.source = { :git => 'https://github.com/flexih/CorePlayer.Swift.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'CorePlayer/*.swift'

  s.requires_arc = true
end