describe command('rustc --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^rustc 1\.99\.1 /) }
end

describe command('cargo --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^cargo 1\.99\.1 /) }
end

describe command('rustup --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^rustup 1\.29\.2 /) }
end

describe os_env('RUST_VERSION') do
  its('content') { should eq '1.99.1' }
end

# Build and run a crate to check that rustc can link with the system C toolchain
describe command('cd "$(mktemp -d)" && cargo new --quiet hello && cd hello && cargo run --quiet') do
  its('exit_status') { should eq 0 }
  its('stdout') { should eq "Hello, world!\n" }
end

# wget is only needed to fetch rustup-init and is removed afterwards
describe command('wget') do
  it { should_not exist }
end
