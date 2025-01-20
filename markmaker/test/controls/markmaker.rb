describe file('/app/markmaker.py') do
  it { should exist }
  its('mode') { should cmp '0755' }
end

describe user('ubuntu') do
  it { should exist }
  its('uid') { should eq 1000 }
  its('gid') { should eq 1000 }
end
