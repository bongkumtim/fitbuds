class Pending < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  # when 'waiting', it means that the user is still waiting for a confirmed_activity
  # when 'successful', it means that the user has already got a confirmed_activity for that particular pending
  enum status: [:waiting, :successful]

  #validations
  validates :activity_id, :user_id, :city, :datetime, :status, presence: true

  # since we've got 2 pending table joins in matches table, we need to create a method to get a pending's matches
  def potential_matches
    declined_by_user = MatchStatus.where(pending_viewer_id: self.id, status: "declined").pluck(:pending_viewed_id)
    declined_by_others = MatchStatus.where(pending_viewed_id: self.id, status: :"declined").pluck(:pending_viewer_id)

    declined_by_others.each do |id|
      unless id.include?(declined_by_user)
        declined_by_user << id
      end
    end

    all_declined_pendings_id = declined_by_user
    # add the current pending id into declined_pendings_id because we don't want the user to be able to accept him/herself
    all_declined_pendings_id << self.id

    all_similar_pendings = Pending.where(
      activity_id: self.activity_id,
      city: self.city,
      datetime: self.datetime,
      status: "waiting"
    )

    return all_similar_pendings.where.not(id: all_declined_pendings_id)
  end
end