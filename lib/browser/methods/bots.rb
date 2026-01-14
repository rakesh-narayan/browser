class Browser
  module Bots
    root = Pathname.new(File.expand_path("../../../..", __FILE__))
    BOTS = YAML.load_file(root.join("bots.yml"))
    SEARCH_ENGINES = YAML.load_file(root.join("search_engines.yml"))

    def self.detect_empty_ua!
      @detect_empty_ua = true
    end

    def self.detect_empty_ua?
      !!@detect_empty_ua
    end

    def bot?
      Browser::Bots.detect_empty_ua? && ua.strip == "" || BOTS.any? {|key, _| ua.include?(key) }
    end

    def search_engine?
      SEARCH_ENGINES.any? {|key, _| ua.include?(key) }
    end

    # Enhanced bot detection that checks both keys and values from BOTS case-insensitively
    # return true if the user agent matches any bot in BOTS hash (by key or value, case-insensitive)
    def bot_detected?
      # Check for empty user agent (same as original bot? method)
      return true if Browser::Bots.detect_empty_ua? && ua.strip == ""
      
      # Normalize user agent to lowercase for case-insensitive matching
      ua_lower = ua.to_s.downcase
      
      # Check both keys and values case-insensitively
      BOTS.any? do |key, value|
        key_str = key.to_s
        value_str = value.to_s
        
        # Check if UA includes the key (case-insensitive)
        ua_lower.include?(key_str.downcase) ||
        # Check if UA includes the value (case-insensitive)
        (!value_str.nil? && !value_str.empty? && ua_lower.include?(value_str.downcase))
      end
    end
  end
end
