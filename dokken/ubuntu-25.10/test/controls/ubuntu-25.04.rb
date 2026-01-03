describe command('lsb_release --release') do
  its('stdout') { should match(/25\.04/) }
end
