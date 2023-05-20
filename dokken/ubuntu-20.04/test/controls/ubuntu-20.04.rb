describe command('lsb_release --release') do
  its('stdout') { should match(/20\.04/) }
end
