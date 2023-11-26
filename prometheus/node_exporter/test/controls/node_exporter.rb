describe command('node_exporter') do
  it { should exist }
end

describe command('node_exporter --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/node_exporter, version/) }
end
