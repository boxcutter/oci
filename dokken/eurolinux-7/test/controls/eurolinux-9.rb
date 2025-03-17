describe file('/etc/os-release') do
  its('content') { should match(/EuroLinux 7/) }
end
