describe command('node --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/v24/) }
end

describe file('/usr/local/bin/docker-entrypoint.sh') do
    it { should exist }
    its('mode') { should cmp '0755' }
end

describe user('node') do
  it { should exist }
  its('uid') { should eq 999 }
  its('gid') { should eq 999 }
end

describe user('ubuntu') do
  it { should exist }
  its('uid') { should eq 1000 }
  its('gid') { should eq 1000 }
end
