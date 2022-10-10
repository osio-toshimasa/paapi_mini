# frozen_string_literal: true

require_relative "test_helper"
require_relative '../lib/paapi_mini'

class TestPaapiMini < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PaapiMini::VERSION
  end

  def test_it_does_something_useful
    res = PaapiMini::search_items(ENV['ACCESS_KEY'], ENV['SECRET_KEY'], ENV['PARTNER_TAG'], "Ruby")
    status_code = res.code.to_i
    puts status_code
    puts res.body
    assert status_code != 404
  end
end
