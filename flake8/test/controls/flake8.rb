describe command('flake8') do
  it { should exist }
end

describe command('flake8 --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/7/) }
end
