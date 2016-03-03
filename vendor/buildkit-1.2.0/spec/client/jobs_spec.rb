require 'spec_helper'

describe Buildkit::Client::Jobs do
  context '#job_log' do
    it 'returns the job log' do
      VCR.use_cassette 'job_log' do
        log = client.job_log('shopify', 'shopify-borgified', 68, "ea3a25bc-5512-49f4-b9fe-3a37a407cedd")
        expect(log.url).to be == "https://api.buildkite.com/v2/organizations/shopify/pipelines/shopify-borgified/builds/68/jobs/ea3a25bc-5512-49f4-b9fe-3a37a407cedd/log"
        expect(log.content).to be == "This is the job's log output"
      end
    end
  end
end
