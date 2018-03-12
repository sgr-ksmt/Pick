Pod::Spec.new do |s|
  s.name             = "Pick"
  s.version          = "0.4.3"
  s.summary          = "Protocol-Oriented PickerViewController"
  s.homepage         = "https://github.com/sgr-ksmt/Pick"
  # s.screenshots     = ""
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/Pick.git", :tag => s.version.to_s }
  s.platform         = :ios, '10.0'
  s.requires_arc     = true
  s.source_files     = "Sources/**/*"
end
