RSpec.describe Heimdallr do
  subject { Heimdallr.config }

  describe '.configure' do
    context 'claims' do
      it 'sets `iss`' do
        Heimdallr.configure do |config|
          config.claims.iss = 'your-domain-name-here'
        end
        
        expect(subject.claims.iss).to eq('your-domain-name-here')
      end

      it 'sets `iat`' do
        Heimdallr.configure do |config|
          config.claims.iat = -> { Time.current.utc.to_i }
        end

        expect(subject.claims.iat).to respond_to(:call)
        expect(subject.claims.iat.call).to eq(Time.current.utc.to_i)
      end
    end

    context 'additional claims' do
      subject { Heimdallr.config.additional_claims.to_h }
      let(:additional_claims) do
        { name: 'Takara', breed: :shiba, gender: :female }
      end

      before do
        Heimdallr.configure do |config|
          additional_claims.each_pair do |k, v|
            config.additional_claims.send("#{k}=", v)
          end
        end
      end

      it { is_expected.to include(**additional_claims) }
    end
  end
end
