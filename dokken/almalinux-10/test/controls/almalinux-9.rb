describe file('/etc/os-release') do
  its('content') { should match(/AlmaLinux 10/) }
end
