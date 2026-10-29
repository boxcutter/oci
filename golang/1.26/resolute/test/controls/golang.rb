describe command('go version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^go version go1\.26\.10 linux\//) }
end

describe os_env('GOTOOLCHAIN') do
  its('content') { should eq 'local' }
end

describe os_env('GOPATH') do
  its('content') { should eq '/go' }
end

describe file('/go') do
  it { should be_directory }
  its('mode') { should cmp '01777' }
end

# cgo needs a working C toolchain
describe command("cd \"$(mktemp -d)\" && printf 'package main\\n\\n// int answer(void) { return 42; }\\nimport \"C\"\\nimport \"fmt\"\\n\\nfunc main() { fmt.Println(C.answer()) }\\n' > main.go && go mod init example.com/cgo >/dev/null 2>&1 && CGO_ENABLED=1 go run .") do
  its('exit_status') { should eq 0 }
  its('stdout') { should eq "42\n" }
end

describe command('git --version') do
  its('exit_status') { should eq 0 }
end
