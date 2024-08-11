describe file('/etc/os-release') do
  its('content') { should match(/Rocky Linux 8/) }
end
