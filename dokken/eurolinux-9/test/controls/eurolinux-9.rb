describe file('/etc/os-release') do
  its('content') { should match(/EuroLinux 9/) }
end
