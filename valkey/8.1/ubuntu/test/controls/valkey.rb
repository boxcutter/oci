describe command('valkey-cli') do
  it { should exist }
end

describe command('valkey-server') do
  it { should exist }
end

describe command('redis-server --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Valkey server v=8\.1/) }
end
