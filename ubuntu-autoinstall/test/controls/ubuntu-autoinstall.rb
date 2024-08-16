describe command('xorriso') do
  it { should exist }
end

describe command ('fdisk') do
  it { should exist }
end

describe file('/app/image-create.sh') do
  it { should exist }
  its('mode') { should cmp '0755' }
end
