class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :submitter, polymorphic: true
end
