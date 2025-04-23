describe command('actionlint') do
  it { should exist }
end

describe command('actionlint -h') do
  its('exit_status') { should eq 0 }
end
