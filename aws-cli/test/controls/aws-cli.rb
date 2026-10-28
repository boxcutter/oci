describe command('aws') do
  it { should exist }
end

describe command('aws --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(%r{aws-cli/2\.39\.0}) }
end

# Used by aws help, the pager and --query workflows, as in the upstream image
%w(less groff jq find).each do |binary|
  describe command(binary) do
    it { should exist }
  end
end
