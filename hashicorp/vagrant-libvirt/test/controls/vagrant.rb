describe command('vagrant') do
  it { should exist }
end

describe command('vagrant plugin list') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/vagrant-libvirt/) }
end

