Pod::Spec.new do |s|
  s.name         = "AnimatedSwiftTable"
  s.version      = "4.2.0"
  s.summary      = "Magically animated table views"
  s.description  = <<-DESC
                    AnimatedSwiftTable magically combines the powers of Changeset and SwiftTable to create automatically animated table views.
                   DESC
  s.homepage     = "https://github.com/bradhilton/AnimatedSwiftTable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brad Hilton" => "brad@skyvive.com" }
  s.source       = { :git => "https://github.com/bradhilton/AnimatedSwiftTable.git", :tag => "4.2.0" }
  s.swift_version = '4.2'

  s.ios.deployment_target = "8.0"

  s.source_files  = "AnimatedSwiftTable", "AnimatedSwiftTable/**/*.{swift,h,m}"
  s.requires_arc = true
  s.dependency 'SwiftTable', '0.4.2'
  s.dependency 'Changeset', '2.0.1'
end
