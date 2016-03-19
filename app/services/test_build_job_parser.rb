class TestBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    begin
      client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
      response = client.job_log('easy-handin', 'test-maven-project', build_number, job_id)

      if response

        if (test_index = response["content"].index("T E S T S")).present?
          response["content"] = response["content"][test_index, response["size"]]

          if response["content"].index("BUILD SUCCESS").present?
            response["status"] = "passed"
          else
            response["content"] = content
            response["status"] = "failed"
          end
        end
      end

      response
    rescue => e
      Rails.logger.error {
        "Error when trying to fetch/parse the test build job for build : #{build_number}, job #{job_id}, #{e.message} #{e.backtrace.join("\n")}"
      }
      nil
    end
  end
end
