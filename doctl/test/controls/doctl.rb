describe command('doctl') do
  it { should exist }
end

describe command('doctl version') do
  its('exit_status') { should eq 0 }
end
