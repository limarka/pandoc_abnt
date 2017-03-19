$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pandoc_abnt"
require 'byebug'


# Inclui método ext
# Ver: https://github.com/ruby/rake/blob/master/lib/rake/ext/string.rb
class String
  # Replace the file extension with +newext+.  If there is no extension on
  # the string, append the new extension to the end.  If the new extension
  # is not given, or is the empty string, remove any existing extension.
  #
  # +ext+ is a user added method for the String class.
  #
  # This String extension comes from Rake
  def ext(newext="")
    return self.dup if [".", ".."].include? self
    if newext != ""
      newext = "." + newext unless newext =~ /^\./
    end
    self.chomp(File.extname(self)) << newext
  end
end

include PandocAbnt
