describe command('pgweb') do
  it { should exist }
end

describe command('pgweb --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Pgweb v/) }
end

describe command('psql') do
  it { should exist }
end