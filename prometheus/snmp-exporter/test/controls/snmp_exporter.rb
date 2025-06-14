describe command('snmp_exporter') do
  it { should exist }
end

describe command('snmp_exporter --version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/snmp_exporter, version/) }
end

describe file('/etc/snmp_exporter/snmp.yml') do
  it { should exist }
end
