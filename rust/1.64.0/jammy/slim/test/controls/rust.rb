describe command('cargo --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/cargo 1/) }
end

describe command('rustc --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/rustc 1/) }
end
