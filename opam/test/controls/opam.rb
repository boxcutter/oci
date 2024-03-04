describe command('utop -version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/The universal toplevel for OCaml, version/) }
end
