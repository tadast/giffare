VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' || !http_message.body.valid_encoding?
  end
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    if name = example.metadata[:cassete].presence
      name = example.metadata[:full_description].split(/\s+/, 2).first.underscore + "/" + name
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    end
    VCR.use_cassette(name, options) { example.call }
  end
end
