json.array!(@postings) do |posting|
  json.extract! posting, :id, :title, :description, :category_id, :rate, :{, :=, :, :=, :date_range, :street, :state, :2}, :zip, :phone, :email
  json.url posting_url(posting, format: :json)
end
