require 'active_support/inflector'

require 'singleton' # standard Ruby lib
require "dude_policy/version"

# nil stuff
require "dude_policy/nil_extension"
require "dude_policy/nil_dude_policy"

# current account stuff
require "dude_policy/dude"
require "dude_policy/base_policy"

# extend app
require "dude_policy/is_a_dude"
require "dude_policy/has_policy"


# core of `dude_policy` is extending `nil` to include `nil.dude` method
NilClass.send(:include, DudePolicy::NilExtesion)

module DudePolicy
  NotAuthorized = Class.new(StandardError)
end
