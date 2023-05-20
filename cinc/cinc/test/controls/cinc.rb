describe command('/opt/cinc/bin/cinc-client') do
  it { should exist }
end

describe command('/opt/cinc/bin/cinc-client --version') do
  its('exit_status') { should eq 127 }
  its('stderr') { should match(/error while loading shared libraries: librt.so.1/) }
end

