require "spec_helper"
require "serverspec"

package = "portshaker"
config  = "/usr/local/etc/portshaker.conf"
user    = "portshaker"
group   = "portshaker"
mirror_base_dir = "/var/cache/portshaker"
ports_dirs = %w[
  /usr/local/poudriere/ports/default
]

describe group(group) do
  it { should exist }
end

describe user(user) do
  it { should exist }
  it { should belong_to_group group }
end

describe package(package) do
  it { should be_installed }
end

describe file mirror_base_dir do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match(/Managed by ansible/) }
  its(:content) { should match Regexp.escape("portshaker") }
end

describe command "portshaker -s" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^portsnap$/) }
end

describe command "portshaker -t" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^default$/) }
end

ports_dirs.each do |d|
  describe file d do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 755 }
  end
end
