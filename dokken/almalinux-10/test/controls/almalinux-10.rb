describe file('/etc/os-release') do
  its('content') { should match(/AlmaLinux Kitten 10/) }
end
