image_value = input('test_container_image')
puts "MISCHA: #{image_value}"

# Everything is based on the curl variant, so curl should exist everywhere
describe command('curl') do
  it { should exist }
end

# The curl variant only should not include anything from the higher level variants
control 'curl' do
  only_if('curl only') do
    input('test_container_image').include?('curl')
  end
  
  describe command('git') do
    it { should_not exist }
  end
  
  describe command('unzip') do
    it { should_not exist }
  end
end


# The scm and top-devel buildpack-deps variants should include git
control 'scm' do
  only_if('scm or buildpack-deps') do
    !input('test_container_image').include?('curl')
  end

  describe command('bzr') do
    it { should_not exist }
  end
  
  describe command('git') do
    it { should exist }
  end
end

# Stuff that is only in the top level variant
control 'scm' do
  only_if('buildpack-deps') do
    !input('test_container_image').include?('curl') && !input('test_container_image').include?('scm')
  end

  describe command('unzip') do
    it { should exist }
  end
end 
