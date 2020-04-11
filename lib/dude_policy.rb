require 'singleton' # standard Ruby lib
require "dude_policy/version"

# nil stuff
require "dude_policy/nil_extension"
require "dude_policy/nil_dude_policy"

# current account stuff
require "dude_policy/dude"

# extend app
require "dude_policy/is_a_dude"
require "dude_policy/has_policy"


# core of `dude_policy` is extending `nil` to include `nil.dude` method
NilClass.send(:include, DudePolicy::NilExtesion)

module DudePolicy; end
