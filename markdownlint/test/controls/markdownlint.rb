describe command('mdl') do
  it { should exist }
end

describe command('mdl --help') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Usage: mdl/) }
end
