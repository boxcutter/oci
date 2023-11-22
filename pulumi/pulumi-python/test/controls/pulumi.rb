describe command('pulumi') do
  it { should exist }
end

describe command('pulumi version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/v/) }
end

describe command('python') do
  it { should exist }
end

describe command('python --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Python 3.9/) }
end
