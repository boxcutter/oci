describe command('lsb_release --release') do
  its('stdout') { should match(/Release:\t14/) }
end
