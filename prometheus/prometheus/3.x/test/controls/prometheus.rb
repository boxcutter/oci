describe command('prometheus') do
  it { should exist }
end

describe command('prometheus --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/prometheus, version 3/) }
end

describe command('promtool') do
  it { should exist }
end

describe command('promtool --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/promtool, version 3/) }
end

describe file('/etc/prometheus/prometheus.yml') do
  it { should exist }
end
