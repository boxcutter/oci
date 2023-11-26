describe command('blackbox_exporter') do
  it { should exist }
end

describe command('blackbox_exporter --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/blackbox_exporter, version/) }
end

describe file('/etc/blackbox_exporter/config.yml') do
  it { should exist }
end