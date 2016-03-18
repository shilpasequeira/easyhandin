class MossBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
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
  end
end
