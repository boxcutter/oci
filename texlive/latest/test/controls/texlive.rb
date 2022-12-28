describe command('latex --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/pdfTeX/) }
end

if os.arch == 'x86_64'
    describe command('biber --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/biber version:/) }
  end
end

describe command('xindy --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/xindy release:/) }
end

describe command('arara --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/arara/) }
end

describe command('python --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Python 3/) }
end

describe command('pygmentize -V') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Pygments version/) }
end
