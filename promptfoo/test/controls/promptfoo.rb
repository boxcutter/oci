describe command('node --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/v24/) }
end

describe command('promptfoo --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/\d+\.\d+\.\d+/) }
end

describe command('pf --version') do
  its('exit_status') { should eq 0 }
end

describe file('/usr/local/lib/node_modules/promptfoo/dist/src/server/index.js') do
  it { should exist }
end

describe command('python --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Python 3/) }
end

describe command('pip3 --version') do
  its('exit_status') { should eq 0 }
end

describe user('promptfoo') do
  it { should exist }
  its('uid') { should eq 1000 }
  its('gid') { should eq 1000 }
end

describe directory('/home/promptfoo/.promptfoo') do
  it { should exist }
  its('owner') { should eq 'promptfoo' }
end

describe os_env('PROMPTFOO_SELF_HOSTED') do
  its('content') { should eq '1' }
end

describe os_env('API_PORT') do
  its('content') { should eq '3000' }
end
