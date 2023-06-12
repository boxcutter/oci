describe command('aws') do
  it { should exist }
end

describe command('aws --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/aws-cli\/2/) }
end
