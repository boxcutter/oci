describe command('black') do
  it { should exist }
end

describe command('black --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^black, 26\.10\.1 /) }
end

# --check exits 1 when a file would be reformatted
describe command("printf 'x = { \"a\":1 }\\n' | black --check -") do
  its('exit_status') { should eq 1 }
end

describe command("printf 'x = { \"a\":1 }\\n' | black -q -") do
  its('exit_status') { should eq 0 }
  its('stdout') { should eq "x = {\"a\": 1}\n" }
end
