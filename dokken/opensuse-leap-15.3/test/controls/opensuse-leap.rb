describe file('/etc/os-release') do
  its('content') { should match(/openSUSE Leap 15.3/) }
end
