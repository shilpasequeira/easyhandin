module Buildkit
  class Client
    # Methods for the Jobs API
    #
    # @see https://buildkite.com/docs/api/jobs
    module Jobs
      # Get a job’s log output
      #
      # @param org [String] Organization slug.
      # @param pipeline [String] Pipeline slug.
      # @param build [Integer] Build number.
      # @param job [String] Job ID.
      # @return [Sawyer::Resource] Hash representing Buildkite job log.
      # @see https://buildkite.com/docs/api/jobs#get-a-jobs-log-output
      # @example
      #   Buildkit.job_log('my-great-org', 'great-pipeline', 42, 'cbff9de5-3fff-440b-b1db-a7409aafa5e5')
      def job_log(org, pipeline, build, job)
        get("/v2/organizations/#{org}/pipelines/#{pipeline}/builds/#{build}/jobs/#{job}/log")
      end
    end
  end
end
