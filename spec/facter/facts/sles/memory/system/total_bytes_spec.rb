# frozen_string_literal: true

describe Facts::Sles::Memory::System::TotalBytes do
  subject(:fact) { Facts::Sles::Memory::System::TotalBytes.new }

  before do
    allow(Facter::Resolvers::Linux::Memory).to receive(:resolve).with(:total).and_return(value)
  end

  describe '#call_the_resolver' do
    let(:value) { 3_331_551_232 }
    let(:value_mb) { 3177.21 }

    it 'calls Facter::Resolvers::Linux::Memory' do
      fact.call_the_resolver
      expect(Facter::Resolvers::Linux::Memory).to have_received(:resolve).with(:total)
    end

    it 'returns available memory fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'memory.system.total_bytes', value: value),
                        an_object_having_attributes(name: 'memorysize_mb', value: value_mb, type: :legacy))
    end
  end

  describe '#call_the_resolver when resolver returns nil' do
    let(:value) { nil }

    it 'returns available memory fact as nil' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'memory.system.total_bytes', value: value),
                        an_object_having_attributes(name: 'memorysize_mb', value: value, type: :legacy))
    end
  end
end