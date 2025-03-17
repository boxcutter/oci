describe file('/etc/os-release') do
  its('content') { should match(/Fedora/) }
  its('content') { should match(/"40 \(Container Image\)/) }
end
