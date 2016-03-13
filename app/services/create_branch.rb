class CreateBranch < ComposableOperations::Operation

	processes :process_repo_name,
              :process_org_name,
              :process_access_token

  # property :property_private, default: "true"
  # property :property_description, default: "A generic description of the repo."

  # def execute

	github = Octokit::Client.new(:access_token => process_access_token)
  #   client.create_repository(process_repo_name, {:organization => process_org_name, :private => property_private, :description => property_description})


# github = Octokit::Client.new( :access_token => "1hw9782egfbioj3fo32hf893fgb32yfv238fy" ) # Octokit 2.x
#github = Octokit::Client.new( :oauth_token => "1hw9782egfbioj3fo32hf893fgb32yfv238fy" ) # Octokit 1.x
# or
#github = Octokit::Client.new(:login => "me", :password => "sekret")

# set up some vars:
#repo = 'mgreensmith/api-test'
ref = 'heads/master'

sha_latest_commit = github.ref(repo, ref).object.sha
sha_base_tree = github.commit(repo, sha_latest_commit).commit.tree.sha
file_name = File.join("some_dir", "new_file.txt")
blob_sha = github.create_blob(repo, Base64.encode64(my_content), "base64")
sha_new_tree = github.create_tree(repo, 
                                   [ { :path => file_name, 
                                       :mode => "100644", 
                                       :type => "blob", 
                                       :sha => blob_sha } ], 
                                   {:base_tree => sha_base_tree }).sha
commit_message = "Committed via Octokit!"
sha_new_commit = github.create_commit(repo, commit_message, sha_new_tree, sha_latest_commit).sha
updated_ref = github.update_ref(repo, ref, sha_new_commit)
puts updated_ref

   end
 end