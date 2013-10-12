json.array!(@users) do |user|
  json.extract! user, :first_name, :last_name, :email, :phone_number, :twitter_handle, :facebook_handle, :zipcode
  json.url user_url(user, format: :json)
end
