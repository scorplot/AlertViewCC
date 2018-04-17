
Pod::Spec.new do |s|
  s.name         = "CCAlertView"
  s.version      = "1.0.1"
  s.summary      = "A short description of CCAlertView."

  s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC

  s.homepage     = "https://github.com/scorplot/CCAlertView"
  s.ios.deployment_target = '7.0'
  s.author           = { 'caomeili' => 'https://github.com/caomeili' }
  s.source           = { :git => 'https://github.com/scorplot/CCAlertView', :tag => s.version.to_s }
  s.source_files = 'Pod/Classes/**/*'
  s.public_header_files = 'Pod/Classes/**/*.h'

end
