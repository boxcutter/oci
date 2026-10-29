describe command('cmake --version') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/^cmake version 4\.4\.5$/) }
end

describe command('ninja --version') do
  its('exit_status') { should eq 0 }
end

describe command('gcc --version') do
  its('exit_status') { should eq 0 }
end

# Configure and build a C and C++ project with the default generator (Unix
# Makefiles) and with Ninja, and check which compiler CMake picked
project = <<~'SH'
  set -e
  dir="$(mktemp -d)"
  cd "$dir"
  printf 'cmake_minimum_required(VERSION 3.20)\nproject(hello C CXX)\nadd_executable(hello_c hello.c)\nadd_executable(hello_cxx hello.cpp)\n' > CMakeLists.txt
  printf '#include <stdio.h>\nint main(void) { puts("hello c"); return 0; }\n' > hello.c
  printf '#include <iostream>\nint main() { std::cout << "hello c++" << std::endl; return 0; }\n' > hello.cpp
SH

describe command(project + 'cmake -S . -B build && cmake --build build >/dev/null && ./build/hello_c && ./build/hello_cxx') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match(/The C compiler identification is GNU /) }
  its('stdout') { should match(/The CXX compiler identification is GNU /) }
  its('stdout') { should match(/^hello c\nhello c\+\+\n\z/) }
end

describe command(project + 'cmake -G Ninja -S . -B build >/dev/null && cmake --build build >/dev/null && ./build/hello_cxx') do
  its('exit_status') { should eq 0 }
  its('stdout') { should eq "hello c++\n" }
end
