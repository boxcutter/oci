describe command('/opt/bats/bin/bats') do
  it { should exist }
end

describe command('/opt/bats/bin/bats --help') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match (/Bats/) }
end
