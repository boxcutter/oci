describe file('/etc/os-release') do
  its('content') { should match(/Oracle Linux Server 7/) }
end
