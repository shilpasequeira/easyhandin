class TestBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    response = client.job_log('easy-handin', 'test-maven-project', build_number, job_id)

    if response

      if (test_index = response["content"].index("T E S T S")).present?
        response["content"] = response["content"][test_index, response["size"]]

        if response["content"].index("BUILD SUCCESS").present?
          response["status"] = "Passed"
        else
          response["content"] = content
          response["status"] = "Failed"
        end
      end
    end

    response
  end
end
