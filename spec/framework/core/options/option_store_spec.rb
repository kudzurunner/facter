# frozen_string_literal: true

describe Facter::OptionStore do
  subject(:option_store) { Facter::OptionStore }

  after do
    option_store.reset
  end

  describe '#all' do
    it 'returns default values' do
      expect(option_store.all).to eq(
        block: true,
        blocked_facts: [],
        cli: nil,
        custom_dir: [],
        custom_facts: true,
        debug: false,
        external_dir: [],
        external_facts: true,
        log_level: :warn,
        ruby: true,
        show_legacy: true,
        trace: false,
        user_query: [],
        verbose: false,
        config: nil,
        cache: true
      )
    end
  end

  describe '#ruby=' do
    context 'when true' do
      it 'sets ruby to true' do
        option_store.ruby = true
        expect(option_store.ruby).to be true
      end
    end

    context 'when false' do
      before do
        option_store.ruby = false
      end

      it 'sets ruby to false' do
        expect(option_store.ruby).to be false
      end

      it 'sets custom facts to false' do
        expect(option_store.custom_facts).to be false
      end

      it 'adds ruby to blocked facts' do
        expect(option_store.blocked_facts).to include('ruby')
      end
    end
  end

  describe '#external_dir=' do
    context 'with empty array' do
      it 'does not override existing array' do
        option_store.external_dir = ['/path1']

        option_store.external_dir = []

        expect(option_store.external_dir).to eq(['/path1'])
      end
    end

    context 'with array' do
      it 'sets dirs' do
        option_store.external_dir = ['/parh1']

        option_store.external_dir = ['/path2']

        expect(option_store.external_dir).to eq(%w[/path2])
      end
    end
  end

  describe '#blocked_facts=' do
    context 'with empty array' do
      it 'does not override existing array' do
        option_store.blocked_facts = ['os']

        option_store.blocked_facts = []

        expect(option_store.blocked_facts).to eq(['os'])
      end
    end

    context 'with array' do
      it 'appends dirs' do
        option_store.blocked_facts = ['os']

        option_store.blocked_facts = ['os2']

        expect(option_store.blocked_facts).to eq(%w[os os2])
      end
    end
  end

  describe '#custom_dir=' do
    context 'with array' do
      it 'overrides dirs' do
        option_store.custom_dir = ['/customdir1']

        option_store.custom_dir = ['/customdir2']

        expect(option_store.custom_dir).to eq(['/customdir2'])
      end

      it 'sets ruby to true' do
        option_store.instance_variable_set(:@ruby, false)

        expect do
          option_store.custom_dir = ['/customdir1']
        end.to change(option_store, :ruby)
          .from(false).to(true)
      end
    end
  end

  describe '#debug' do
    context 'when true' do
      it 'sets debug to true and log_level to :debug' do
        expect do
          option_store.debug = true
        end.to change(option_store, :log_level)
          .from(:warn).to(:debug)
      end
    end

    context 'when false' do
      it 'sets log_level to default (:warn)' do
        option_store.instance_variable_set(:@log_level, :info)

        expect do
          option_store.debug = false
        end.to change(option_store, :log_level)
          .from(:info).to(:warn)
      end
    end
  end

  describe '#verbose=' do
    context 'when true' do
      it 'sets log_level to :info' do
        expect do
          option_store.verbose = true
        end.to change(option_store, :log_level)
          .from(:warn).to(:info)
      end
    end

    context 'when false' do
      it 'sets log_level to default (:warn)' do
        option_store.instance_variable_set(:@log_level, :debug)

        expect do
          option_store.debug = false
        end.to change(option_store, :log_level)
          .from(:debug).to(:warn)
      end
    end
  end

  describe '#custom_facts=' do
    context 'when true' do
      it 'sets ruby to true' do
        option_store.instance_variable_set(:@ruby, false)

        expect do
          option_store.custom_facts = true
        end.to change(option_store, :ruby)
          .from(false).to(true)
      end
    end
  end

  describe '#log_level=' do
    let(:facter_log) { class_spy('Facter::Log') }

    before do
      stub_const('Facter::Log', facter_log)
    end

    context 'when :trace' do
      it 'sets log_level to :debug' do
        expect do
          option_store.log_level = :trace
        end.to change(option_store, :log_level)
          .from(:warn).to(:debug)
      end

      it 'sets the Facter::Log level' do
        option_store.trace = true
        expect(facter_log).to have_received(:level=).with(:debug)
      end
    end

    context 'when :debug' do
      it 'sets logl_level :debug' do
        expect do
          option_store.log_level = :debug
        end.to change(option_store, :log_level)
          .from(:warn).to(:debug)
      end
    end

    context 'when :info' do
      it 'sets log_level to :info' do
        expect do
          option_store.log_level = :info
        end.to change(option_store, :log_level)
          .from(:warn).to(:info)
      end
    end
  end

  describe '#show_legacy=' do
    context 'when true' do
      it 'sets ruby to true' do
        option_store.instance_variable_set(:@ruby, false)

        expect do
          option_store.show_legacy = true
        end.to change(option_store, :ruby)
          .from(false).to(true)
      end
    end

    context 'when false' do
      it 'sets show_legacy to false' do
        option_store.show_legacy = false
        expect(option_store.show_legacy).to be false
      end
    end
  end

  describe '#trace=' do
    context 'when true' do
      it 'sets log_level to :debug' do
        expect do
          option_store.trace = true
        end.to change(option_store, :log_level)
          .from(:warn).to(:debug)
      end
    end

    context 'when false' do
      it 'sets log_level to default (:warn)' do
        option_store.instance_variable_set(:@log_level, :debug)

        expect do
          option_store.trace = false
        end.to change(option_store, :log_level)
          .from(:debug).to(:warn)
      end
    end
  end

  describe '#send' do
    it 'sets values for attributes' do
      option_store.instance_variable_set(:@ruby, true)

      expect do
        option_store.set('ruby', false)
      end.to change(option_store, :ruby)
        .from(true).to(false)
    end
  end
end