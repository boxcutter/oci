describe command('lsb_release --release') do
  its('stdout') { should match(/22\.04/) }
end
