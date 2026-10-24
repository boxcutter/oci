describe command('lsb_release --release') do
  its('stdout') { should match(/26\.10/) }
end
