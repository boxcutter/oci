describe file('/etc/os-release') do
  its('content') { should match(/CentOS Linux 7/) }
end
