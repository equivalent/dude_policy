require 'singleton' # standard Ruby lib
require "dude_policy/version"
require "dude_policy/nil_extension"
require "dude_policy/nil_dude_policy"


# core of `dude_policy` is extending `nil` to include `nil.dude` method
NilClass.send(:include, DudePolicy::NilExtesion)

module DudePolicy
  class Error < StandardError; end
end
