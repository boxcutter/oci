describe command('meshcmd') do
  it { should exist }
end

describe command('meshcmd') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/MeshCentral Command \(MeshCmd\)  v1\.1\.9/) }
end

describe command('meshcmd help AmtPower') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/meshcmd amtpower --reset/) }
end
