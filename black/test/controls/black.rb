describe command('black') do
  it { should exist }
end

describe command('black --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/black/) }
end
