Pod::Spec.new do |s|
  s.name     = 'Cedar-Taptera'
  s.version  = '0.0.6'
  s.license  = 'MIT'
  s.summary  = 'BDD-style testing using Objective-C.'
  s.homepage = 'https://github.com/Taptera/cedar'
  s.author   = { 'Pivotal Labs' => 'http://pivotallabs.com' }
  s.license  = { :type => 'MIT', :file => 'MIT.LICENSE' }
  s.source   = { :git => 'https://github.com/Taptera/cedar.git', :tag => '#{s.version}' }
  
  files_pattern = 'Source/**/*.{h,m,mm}'

  s.ios.header_dir = 'Cedar-iOS'
  s.ios.exclude_files = "/CDROTestRunner.m$/"
  
  s.osx.exclude_files = "/iPhone/"
  
  s.library = 'stdc++'
end