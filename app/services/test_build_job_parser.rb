class TestBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    response = client.job_log('easy-handin', 'test-maven-project', build_number, job_id)
    output = nil

    if response
      content = response["content"]

      if content.index("T E S T S").present?
        output["content"] = content[content.index("T E S T S"), content.length]

        if content.index("BUILD SUCCESS").present?
          output["status"] = "Passed"
        end
      else
        output["content"] = content
        output["status"] = "Failed"
      end
    end

    output
  end
end
