class MossBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    begin
      client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
      build_response = client.build('easy-handin', 'moss-plagiarism-check', build_number)

      response = {status: "in_progress", content: nil}

      if build_response
        if build_response["state"] == "scheduled" || build_response["state"] == "running"
          response["status"] = "in_progress"
        elsif build_response["state"] == "failed"
          response["status"] = "error"
        elsif build_response["state"] == "passed" || build_response["state"] == "finished"
          response["status"] = "finished"

          job_response = client.job_log('easy-handin', 'moss-plagiarism-check', build_number, job_id)

          if job_response["content"].present?
            if (url_index = job_response["content"].index("MOSS RESULT@")).present?
              url = job_response["content"][url_index, job_response["size"]]
              url.slice! "MOSS RESULT@"
              response["content"] = url.strip
            end
          end
        end
      end

      response
    rescue => e
      Rails.logger.error {
        "Error when trying to fetch/parse the moss build job for build : #{build_number}, job #{job_id}, #{e.message} #{e.backtrace.join("\n")}"
      }
      nil
    end
  end
end
