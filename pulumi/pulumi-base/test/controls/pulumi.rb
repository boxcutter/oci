describe command('pulumi') do
  it { should exist }
end

describe command('pulumi version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/v/) }
end
