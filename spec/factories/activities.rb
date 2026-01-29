FactoryBot.define do
  factory :activity do
    transient do
      activity_account { create(:account) }
    end

    account { activity_account }
    user    { create(:user, account: activity_account) }

    name { "Mop the floor" }
    activity_type { :chore }
    status { :draft }
    period { :week }
    frequency { 1 }
    times_per_period { 7 }
  end
end
