describe command('hadolint') do
  it { should exist }
end

describe command('hadolint --help') do
  its('exit_status') { should eq 0 }
end

describe command('hadolint --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/2\.15\.1/) }
end

describe command('echo "FROM debian:latest" | hadolint -') do
  its('exit_status') { should_not eq 0 }
  its('stdout') { should match(/DL3007/) }
end
