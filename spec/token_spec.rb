require 'tempfile'

class DummyToken
  include Heimdallr::Token
end

RSpec.describe Heimdallr::Token do
  let!(:uuid)            { '75e3f492-73d3-4148-aaa9-0ee31b1f7041' }
  let!(:issuer)          { 'supercalifragilisticexpialidocious' }
  let!(:time_issued)     { 1554611490 }
  let!(:time_not_before) { 1554611492 }
  let!(:time_expiration) { 1554613290 }
  let(:secret_key)       { '5482e9210cab6818e6c11034a5e0d068d131a083a1f1e4b0904bd9158fa1a29cad2b61fdef67f95264925018392e7329165b47c2d0b5104d6277f68541766a42' }

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

    describe '#algorithm' do
      before do
        subject.algorithm = :HS512
      end
      it { expect(subject.algorithm).to eq(:HS512) }
    end

    describe '#encode' do
      it 'raises an exception when the algorithm does not exist' do
        subject.algorithm = :SHIBE
        expect { subject.encode }.to raise_exception(RuntimeError, 'SHIBE is not a valid algorithm.')
      end

      context 'HMAC' do
        it 'generates a valid JWT' do
          subject.algorithm = :HS512
          Heimdallr.configure { |c| c.secret_key = secret_key }
          expect(subject.encode).to eq('eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJzdXBlcmNhbGlmcmFnaWxpc3RpY2V4cGlhbGlkb2Npb3VzIiwiaWF0IjoxNTU0NjExNDkwLCJuYmYiOjE1NTQ2MTE0OTIsImV4cCI6MTU1NDYxMzI5MCwianRpIjoiNzVlM2Y0OTItNzNkMy00MTQ4LWFhYTktMGVlMzFiMWY3MDQxIiwibmFtZSI6IlRha2FyYSIsImJyZWVkIjoic2hpYmEiLCJnZW5kZXIiOiJmZW1hbGUiLCJzY29wZXMiOltdfQ.iiETcKUVE8ysoRAaKWIJMxVhLYwZCVK9KC7QjU2mlpfbZ_7vxAqXUEwCichrkqSegFJVlhqA7gML26wi9GCwQQ')
        end
      end

      context 'RSA' do
        it 'generates a valid JWT' do
          subject.algorithm = :RS512
          Heimdallr.configure { |c| c.secret_key_path = 'spec/fixtures/top-secret.pem' }
          expect(subject.encode).to eq('eyJhbGciOiJSUzUxMiJ9.eyJpc3MiOiJzdXBlcmNhbGlmcmFnaWxpc3RpY2V4cGlhbGlkb2Npb3VzIiwiaWF0IjoxNTU0NjExNDkwLCJuYmYiOjE1NTQ2MTE0OTIsImV4cCI6MTU1NDYxMzI5MCwianRpIjoiNzVlM2Y0OTItNzNkMy00MTQ4LWFhYTktMGVlMzFiMWY3MDQxIiwibmFtZSI6IlRha2FyYSIsImJyZWVkIjoic2hpYmEiLCJnZW5kZXIiOiJmZW1hbGUiLCJzY29wZXMiOltdfQ.aPtbNRBNYigdPWv-se5hvEnXUzr-eyx7kCliwa_-HwKiCgYsKPly9cOezH7S9vHLrBKCfNl2uzwHZ0FrS3PdqZzUUc5yGZvw2Cx-geEPpJejxAJ6GaFyhMWKuA1UgpmMVJ7cjwY7yrjuPiT3tYZqwVMUxLNwlQI-0D_9cLQYS5PMVOpPpKQipZksnlC6ge3K2yrUQ1XgoTVxLIxTrciscH2H8ptEDd6eoaTePWXD5149Kqqt9ToqmyeaTyHT7bOiPY-aKFzW7367N2XWWsM4eU5o7wdjQeoXoJMXxD_IRtb6fbhKO3ReV02o295nhbnatJFHNWCTDm5r6fCKaoOX4A')
        end
      end
    end
  end
end
