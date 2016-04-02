class TestBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    begin
      client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
      build_response = client.build('easy-handin', 'test-maven-project', build_number)

      response = {status: "in_progress", content: nil}

      if build_response.present?
        if build_response["state"] == "scheduled" || build_response["state"] == "running"
          response["status"] = "in_progress"
        elsif build_response["state"] == "failed"
          response["status"] = "error"
        elsif build_response["state"] == "passed" || build_response["state"] == "finished"
          response["status"] = "passed"

          job_response = client.job_log('easy-handin', 'test-maven-project', build_number, job_id)

          if job_response.present?
            if (test_index = job_response["content"].index("T E S T S")).present?
              response["content"] = job_response["content"][test_index, job_response["size"]]

              if job_response["content"].index("BUILD FAILURE").present?
                response["status"] = "failed"
              end
            else
              response["status"] = "error"
            end
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
