class DummyToken
  include Heimdallr::Token
end

RSpec.describe Heimdallr::Token do
  let!(:uuid)            { SecureRandom.uuid }
  let!(:issuer)          { 'supercalifragilisticexpialidocious' }
  let!(:time_issued)     { Time.current.utc.to_i }
  let!(:time_not_before) { 2.seconds.from_now.utc.to_i }
  let!(:time_expiration) { 30.minutes.from_now.utc.to_i }

  context 'instantiating manually' do
    subject do
      DummyToken.new.tap do |tok|
        tok.claims.iss = issuer
        tok.claims.iat = -> { time_issued }
        tok.claims.nbf = -> { time_not_before }
        tok.claims.exp = -> { time_expiration }
        tok.claims.jti = -> { uuid }
      end
    end
  
    describe '#claims' do
      it 'iss' do
        expect(subject.claims.iss).to eq(issuer)
      end
  
      it 'iat' do
        expect(subject.claims.iat).to respond_to(:call)
        expect(subject.claims.iat.call).to eq(time_issued)
      end

      it 'nbf' do
        expect(subject.claims.nbf).to respond_to(:call)
        expect(subject.claims.nbf.call).to eq(time_not_before)
      end

      it 'exp' do
        expect(subject.claims.exp).to respond_to(:call)
        expect(subject.claims.exp.call).to eq(time_expiration)
      end

      it 'jti' do
        expect(subject.claims.jti).to respond_to(:call)
        expect(subject.claims.jti.call).to eq(uuid)
      end
    end
  
    describe '#resolve_claims' do
      let(:resolved) { subject.resolve_claims }

      it 'iss' do
        expect(resolved[:iss]).to eq(issuer)
      end
  
      it 'iat' do
        expect(resolved[:iat]).to eq(time_issued)
      end

      it 'nbf' do
        expect(resolved[:nbf]).to eq(time_not_before)
      end

      it 'exp' do
        expect(resolved[:exp]).to eq(time_expiration)
      end

      it 'jti' do
        expect(resolved[:jti]).to eq(uuid)
      end
    end
  end
end
