describe command('actionlint') do
  it { should exist }
end

describe command('actionlint -h') do
  its('exit_status') { should eq 0 }
end

describe command('actionlint -version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^1\.7\.12$/) }
end

describe command('shellcheck') do
  it { should exist }
end

describe command('pyflakes') do
  it { should exist }
end
