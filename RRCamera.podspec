Pod::Spec.new do |s|
  s.name             = "RRCamera"
  s.version          = "0.1.0"
  s.summary          = "RRCamera."
  s.description      = <<-DESC
  		       RRCamera handle camera on iOS with crop feature.
                        DESC
  s.homepage         = "https://github.com/remirobert/RRCamera"
  s.license          = 'MIT'
  s.author           = { "remirobert" => "remi.robert@epitech.eu" }
  s.source           = { :git => "https://github.com/remirobert/RRCamera.git", :commit => "41942b7be02d4a25b90dff99ab2014b886916eed", :tag => 'v0.1.0' }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'RRCamera/'

end