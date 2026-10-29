describe command('flake8') do
  it { should exist }
end

describe command('flake8 --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^7\.5\.0 /) }
  its('stdout') { should match(/mccabe: 0\.7\.0, pycodestyle: 2\.15\.0, pyflakes: 4\.1\.0/) }
end

describe command("printf 'import os\\n' | flake8 -") do
  its('exit_status') { should eq 1 }
  its('stdout') { should match(/F401 'os' imported but unused/) }
end
