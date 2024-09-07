describe command('node --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/v18/) }
end

describe file('/usr/local/bin/docker-entrypoint.sh') do
    it { should exist }
    its('mode') { should cmp '0755' }
end