%w(
  bundle
  gem
  irb
  ruby
).each do |cmd|
  describe command(cmd) do
    it { should exist }
  end
end

describe command('ruby --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/ruby 3/) }
end

describe command('gem --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/3\./) }
end

describe command('bundle --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/Bundler version/) }
end

describe command('irb --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/irb/) }
end
