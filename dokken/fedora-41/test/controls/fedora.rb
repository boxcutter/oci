describe file('/etc/os-release') do
  its('content') { should match(/Fedora/) }
  its('content') { should match(/"41 \(Container Image\)/) }
end
