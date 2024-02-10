describe command('alertmanager') do
  it { should exist }
end

describe command('alertmanager --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/alertmanager, version/) }
end

describe command('amtool') do
  it { should exist }
end

describe command('amtool  --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/amtool, version/) }
end
