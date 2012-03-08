FactoryGirl.define do
  factory :user do
    sequence(:email) { "info@email#{rand(1..6)}.org"}
    password "secret"
    password_confirmation "secret"
  end
end