describe command('generator') do
  it { should exist }
end

describe command('generator -h') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/usage: generator/) }
end
