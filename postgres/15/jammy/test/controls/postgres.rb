describe command ('postgres') do
  it { should exist }
end

describe command('postgres --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/postgres \(PostgreSQL\)/) }
end
