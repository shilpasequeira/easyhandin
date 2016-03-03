require 'spec_helper'

describe Buildkit do
  it 'has a version number' do
    expect(Buildkit::VERSION).not_to be nil
  end

  describe '#root' do
    it 'fetches the API root' do
      VCR.use_cassette 'root' do
        root = client.root
        expect(root.response).to be == 'Hello World'
      end
    end
  end

  describe 'errors' do
    it 'raises a Buildkit::NotFound on 404 responses' do
      VCR.use_cassette '404' do
        expect { client.get('/404-not-found') }.to raise_error(Buildkit::NotFound)
      end
    end
  end
end
