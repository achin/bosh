require 'spec_helper'
require 'bosh/director/compiled_package_group'

module Bosh::Director
  describe CompiledPackageGroup do
    let(:release_version) { Models::ReleaseVersion.make }
    let(:stemcell) { Models::Stemcell.make }

    let(:package1) { Models::Package.make }
    let(:package2) { Models::Package.make }
    let(:package3) { Models::Package.make }

    let(:dependency_key1) { 'fake_dependency_key_1' }
    let(:dependency_key2) { 'fake_dependency_key_2' }

    let!(:compiled_package1) { Models::CompiledPackage.make(package: package1, stemcell: stemcell, dependency_key: dependency_key1) }
    let!(:compiled_package2) { Models::CompiledPackage.make(package: package2, stemcell: stemcell, dependency_key: dependency_key2) }

    subject(:package_group) { CompiledPackageGroup.new(release_version, stemcell) }

    before do
      release_version.add_package(package1)
      release_version.stub(:package_dependency_key).with(package1.name).and_return(dependency_key1)
    end

    describe '#compiled_packages' do
      it 'returns list of packages for the given release version and stemcell' do
        expect(package_group.compiled_packages).to eq([compiled_package1])
      end

      it 'does not return nil for packages in the release version that are not compiled' do
        release_version.add_package(package3)
        release_version.stub(:package_dependency_key).with(package3.name).and_return('')

        expect(package_group.compiled_packages).to eq([compiled_package1])
      end
    end
  end
end
