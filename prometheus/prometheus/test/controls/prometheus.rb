describe command('prometheus') do
  it { should exist }
end

describe command('prometheus --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/prometheus, version/) }
end

describe command('promtool') do
  it { should exist }
end

describe command('promtool --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/promtool, version/) }
end

describe file('/etc/prometheus/prometheus.yml') do
  it { should exist }
end

describe directory('/usr/share/prometheus/console_libraries') do
  it { should exist }
end

describe file('/usr/share/prometheus/console_libraries/prom.lib') do
  it { should exist }
end

describe directory('/usr/share/prometheus/consoles') do
  it { should exist }
end

describe file('/usr/share/prometheus/consoles/prometheus.html') do
  it { should exist }
end
