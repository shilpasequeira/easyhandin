
class MossBuildJobParser < ComposableOperations::Operation
  processes :build_number, :job_id

  def execute
    client = Buildkit.new(token: ENV['BUILDKITE_ACCESS_TOKEN'])
    response = client.job_log('easy-handin', 'moss-plagiarism-check', build_number, job_id)

    if response
      response['content'] 
    else
      nil
    end  
  end
end