# frozen_string_literal: true

node.reverse_merge!(YAML.load_file("#{File.dirname(__FILE__)}/../nodes/acc.yml"))

include_recipe '../cookbooks/acc/default.rb'
