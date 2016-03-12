class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :submitter, polymorphic: true

  enum test_result: [ :passed, :failed, :error, :in_progress ]

end
