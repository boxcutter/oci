# JRE 8 prints its version to stderr
describe command('java -version') do
  its('exit_status') { should eq 0 }
  its('stderr') { should match(/openjdk version "1\.8\.0_504"/) }
  its('stderr') { should match(/Temurin/) }
end

describe command('javac') do
  it { should_not exist }
end

describe os_env('JAVA_HOME') do
  its('content') { should eq '/opt/java/openjdk' }
end

describe os_env('LANG') do
  its('content') { should eq 'en_US.UTF-8' }
end

describe file('/opt/java/openjdk/lib/security/cacerts') do
  it { should exist }
end

describe file('/__cacert_entrypoint.sh') do
  it { should exist }
  its('mode') { should cmp '0755' }
end

# GPLv2 with the Classpath Exception requires the license and notices to ship with the binaries
%w(LICENSE ASSEMBLY_EXCEPTION NOTICE THIRD_PARTY_README).each do |name|
  describe file("/opt/java/openjdk/#{name}") do
    it { should exist }
  end
end

# The roots named at https://openjdk.org/emudhra must not be trusted
describe command('keytool -list -v -keystore /opt/java/openjdk/lib/security/cacerts -storepass changeit') do
  its('exit_status') { should eq 0 }
  ['emSign ECC Root CA - G3', 'emSign Root CA - G1', 'emSign Root CA - G2', 'AAA Certificate Services'].each do |cn|
    its('stdout') { should_not include "CN=#{cn}," }
  end
end
