describe file('/etc/os-release') do
  it { should exist }
  its('content') { should match(/^VERSION_CODENAME=forky$/) }
end
