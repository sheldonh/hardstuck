class Match < ApplicationRecord
  belongs_to :winning_member, class_name: "Member"
  belongs_to :losing_member, class_name: "Member"
end
