# frozen_string_literal: true

require 'pathname'
lib_path = File.join( File.dirname(__FILE__), '..', 'lib', 'facter' )

FACTER_VERSION = File.read("#{lib_path}/VERSION").strip
