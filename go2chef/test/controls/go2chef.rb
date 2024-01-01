describe command('go2chef -h') do
  its('exit_status') { should eq 2 }
  its('stderr') { should match(/Usage of go2chef:/) }
end
