json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :references, :references, :when
  json.url reservation_url(reservation, format: :json)
end
