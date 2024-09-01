describe command('cmake --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/cmake version/) }
  end
  
  describe command('gcc --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/gcc/) }
  end
  