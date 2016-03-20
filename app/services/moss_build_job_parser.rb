class MossBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    begin
      client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
      response = client.job_log('easy-handin', 'moss-plagiarism-check', build_number, job_id)

      if response["content"].present?
        if (url_index = response["content"].index("MOSS RESULT@")).present?
          url = response["content"][url_index, response["size"]]
          url.slice! "MOSS RESULT@"
          url
        end
      else
        nil
      end
    rescue => e
      Rails.logger.error {
        "Error when trying to fetch/parse the moss build job for build : #{build_number}, job #{job_id}, #{e.message} #{e.backtrace.join("\n")}"
      }
      nil
    end
  end
end
