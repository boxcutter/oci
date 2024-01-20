describe file('/etc/os-release') do
  its('content') { should match(/Amazon Linux 2/) }
end
