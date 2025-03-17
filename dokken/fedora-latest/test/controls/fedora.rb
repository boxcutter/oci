describe file('/etc/os-release') do
  its('content') { should match(/Fedora/) }
end
