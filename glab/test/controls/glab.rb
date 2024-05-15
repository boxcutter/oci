describe command('glab --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/glab version/) }
end

describe command('docker') do
  it { should exist }
end

describe command('git') do
  it { should exist }
end

describe command('ssh') do
  it { should exist }
end
