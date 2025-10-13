describe file('/etc/os-release') do
  it { should exist }
  its('content') { should match(/^VERSION-CODENAME=forky$/) }
end
