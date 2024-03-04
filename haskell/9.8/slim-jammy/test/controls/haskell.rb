describe command('stack --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/Version 2/) }
end

describe command('cabal --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/cabal-install version/) }
end

describe command('ghci --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/The Glorious Glasgow Haskell Compilation System, version/) }
end
