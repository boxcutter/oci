# miscellaneous dependencies for TeX Live tools
%w(
  make
  fontconfig
  perl
  default-jre
  libgetopt-long-descriptive-perl
  libdigest-perl-md5-perl
  libncurses5
  libncurses6
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# for latexindent
%w(
  libunicode-linebreak-perl
  libfile-homedir-perl
  libyaml-tiny-perl
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# for eps conversion
describe package('ghostscript') do
  it { should be_installed }
end

# for metafont
describe package('libsm6') do
  it { should be_installed }
end

# for syntax highlighting
%w(
  python3
  python3-pygments
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

# for gnuplot backend of pgfplots
describe package('gnuplot-nox') do
  it { should be_installed }
end
