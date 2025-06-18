%w(
  jsonnet
  jsonnet-deps
  jsonnet-lint
  jsonnetfmt
  mixtool
).each do |binary|
  describe command(binary) do
    it { should exist }
  end
end
