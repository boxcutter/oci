describe command('doctl') do
  it { should exist }
end

describe command('doctl version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^doctl version 2\.1\.0/) }
end

describe command('kubectl') do
  it { should exist }
end

describe command('kubectl version --client') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Client Version: v1\.37\.2/) }
end

describe user('doctl') do
  it { should exist }
end

%w(jq ssh vim nano curl).each do |cmd|
  describe command(cmd) do
    it { should exist }
  end
end
