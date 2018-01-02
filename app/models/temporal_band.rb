class TemporalBand < ApplicationRecord
  serialize :members
  validates :name, presence: true
  validates :event, presence: true
  def members_database #TODO: membersに後で変更
    TemporalBandMember.where(band_id: self.id).pluck('name')
  end
end
