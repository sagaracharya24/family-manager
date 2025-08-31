#!/usr/bin/env ruby

require 'xcodeproj'

# Open the Xcode project
project_path = './ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
runner_target = project.targets.find { |target| target.name == 'Runner' }

# Current configurations
debug_config = project.build_configurations.find { |config| config.name == 'Debug' }
release_config = project.build_configurations.find { |config| config.name == 'Release' }
profile_config = project.build_configurations.find { |config| config.name == 'Profile' }

# Create new build configurations for flavors
%w[dev prod].each do |flavor|
  %w[Debug Release Profile].each do |config_type|
    config_name = "#{config_type}-#{flavor}"
    
    # Skip if already exists
    next if project.build_configurations.any? { |config| config.name == config_name }
    
    # Create new configuration
    base_config = project.build_configurations.find { |config| config.name == config_type }
    new_config = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
    new_config.name = config_name
    new_config.base_configuration_reference = base_config.base_configuration_reference
    new_config.build_settings = base_config.build_settings.dup
    
    # Add flavor-specific settings
    new_config.build_settings['FLUTTER_TARGET'] = "lib/main_#{flavor}.dart"
    new_config.build_settings['FLUTTER_FLAVOR'] = flavor
    new_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = flavor == 'prod' ? 'com.ourhome.familymanager' : 'com.ourhome.familymanager.dev'
    new_config.build_settings['PRODUCT_NAME'] = flavor == 'prod' ? 'OurHome' : 'OurHome Dev'
    
    # Set configuration reference to flavor-specific xcconfig
    config_file_name = "#{config_type}-#{flavor}.xcconfig"
    flutter_group = project.main_group.find_subpath('Flutter', true)
    config_file_ref = flutter_group.files.find { |file| file.path == config_file_name }
    if config_file_ref.nil?
      config_file_ref = flutter_group.new_reference(config_file_name)
    end
    new_config.base_configuration_reference = config_file_ref
    
    # Add to project
    project.build_configurations << new_config
    runner_target.build_configurations << new_config
  end
end

# Create schemes for each flavor
%w[dev prod].each do |flavor|
  scheme_name = "Runner-#{flavor}"
  scheme_path = "./ios/Runner.xcodeproj/xcshareddata/xcschemes/#{scheme_name}.xcscheme"
  
  next if File.exist?(scheme_path)
  
  scheme = Xcodeproj::XCScheme.new
  scheme.set_launch_target(runner_target)
  
  # Set build configurations for each action
  scheme.launch_action.build_configuration = "Debug-#{flavor}"
  scheme.test_action.build_configuration = "Debug-#{flavor}"
  scheme.profile_action.build_configuration = "Profile-#{flavor}"
  scheme.analyze_action.build_configuration = "Debug-#{flavor}"
  scheme.archive_action.build_configuration = "Release-#{flavor}"
  
  # Save scheme
  scheme.save_as(project_path, scheme_name, true)
end

# Save the project
project.save

puts "iOS flavors setup completed!"
puts "Available configurations: #{project.build_configurations.map(&:name).join(', ')}"
puts "Available schemes: Runner, Runner-dev, Runner-prod"