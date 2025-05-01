describe command('redis-server') do
  it { should exist }
end

describe command('redis-server --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Redis server v=7\.4/) }
end
