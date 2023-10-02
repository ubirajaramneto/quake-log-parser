# test_runner.rb

# Add the 'lib' directory to the load path
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

# Require all test files
Dir.glob('./spec/unit/*_test.rb').each { |file| require file }