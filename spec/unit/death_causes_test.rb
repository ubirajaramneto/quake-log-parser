require 'minitest/autorun'
require_relative '../../src/lib/death_causes'

class DeathCausesTest < Minitest::Test
  include QuakeLog::DeathCauses

  def test_valid_death_cause
    # Test a selection of known valid death causes
    valid_causes = ["MOD_SHOTGUN", "MOD_RAILGUN", "MOD_SUICIDE", "MOD_GRAPPLE"]

    valid_causes.each do |cause|
      assert valid_death_cause?(cause), "Expected #{cause} to be valid"
    end
  end

  def test_invalid_death_cause
    # Test some random invalid death causes
    invalid_causes = ["MOD_FAKE", "INVALID", "MOD_TEST", "MOD_GUN"]

    invalid_causes.each do |cause|
      refute valid_death_cause?(cause), "Expected #{cause} to be invalid"
    end
  end

  def test_edge_case_empty_string
    # An empty string should be considered an invalid death cause
    refute valid_death_cause?("")
  end

  def test_edge_case_nil_value
    # nil should be considered an invalid death cause
    refute valid_death_cause?(nil)
  end

  def test_case_sensitivity
    # Death causes should be case sensitive, so a valid cause in lowercase should be invalid
    cause = "mod_shotgun"
    refute valid_death_cause?(cause), "Expected #{cause} to be invalid due to case difference"
  end
end
