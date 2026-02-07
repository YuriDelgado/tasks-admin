FactoryBot.define do
  factory :activity_override do
    association :activity

    assigned_to do
      association :user, account: activity.account
    end

    created_by do
      association :user, account: activity.account, role: :admin
    end

    date_from { Date.today }
    date_to   { Date.today + 7.days }

    reason { "Vacation override" }

      trait :short_range do
        date_to { date_from + 1.day }
      end

      trait :long_range do
        date_to { date_from + 30.days }
      end
  end
end
