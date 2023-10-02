module QuakeLog
  # Provides functionality to validate various causes of death within the game.
  #
  # @author [Ubirajara Marsicano Neto]
  module DeathCauses
    # A list of valid causes of death in the game.
    # These represent various weapons and environmental hazards that can result in a player's death.
    VALID_DEATH_CAUSES = [
      "MOD_UNKNOWN",
      "MOD_SHOTGUN",
      "MOD_GAUNTLET",
      "MOD_MACHINEGUN",
      "MOD_GRENADE",
      "MOD_GRENADE_SPLASH",
      "MOD_ROCKET",
      "MOD_ROCKET_SPLASH",
      "MOD_PLASMA",
      "MOD_PLASMA_SPLASH",
      "MOD_RAILGUN",
      "MOD_LIGHTNING",
      "MOD_BFG",
      "MOD_BFG_SPLASH",
      "MOD_WATER",
      "MOD_SLIME",
      "MOD_LAVA",
      "MOD_CRUSH",
      "MOD_TELEFRAG",
      "MOD_FALLING",
      "MOD_SUICIDE",
      "MOD_TARGET_LASER",
      "MOD_TRIGGER_HURT",
      "MOD_NAIL",
      "MOD_CHAINGUN",
      "MOD_PROXIMITY_MINE",
      "MOD_KAMIKAZE",
      "MOD_JUICED",
      "MOD_GRAPPLE"
    ].freeze

    # Checks if a given cause of death is valid within the game.
    #
    # @param cause [String] the name of the death cause to validate
    # @return [Boolean] true if the cause is valid, false otherwise
    # @example Check if a death cause is valid
    #   valid_death_cause?("MOD_SHOTGUN") #=> true
    #   valid_death_cause?("INVALID_CAUSE") #=> false
    def valid_death_cause?(cause)
      VALID_DEATH_CAUSES.include?(cause)
    end
  end
end
