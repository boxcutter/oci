describe command('fpm') do
    it { should exist }
end

describe command('fpm -h') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/This is fpm version/) }
end