describe command ('postgres') do
  it { should exist }
end

describe command('postgres --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/postgres \(PostgreSQL\)/) }
end

describe file('/usr/local/bin/docker-entrypoint.sh') do
    it { should exist }
    its('mode') { should cmp '0755' }
end