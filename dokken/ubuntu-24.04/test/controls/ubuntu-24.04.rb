describe command('lsb_release --release') do
  its('stdout') { should match(/24\.04/) }
end
