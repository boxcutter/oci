describe command('go version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/go version go1/) }
end
