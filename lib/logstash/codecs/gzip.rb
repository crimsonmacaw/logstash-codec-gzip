# encoding: utf-8
require 'zlib'
require 'stringio'

require "logstash/codecs/base"
require "logstash/namespace"

# This  codec will append a string to the message field
# of an event, either in the decoding or encoding methods
#
# This is only intended to be used as an example.
#
# input {
#   stdin { codec =>  }
# }
#
# or
#
# output {
#   stdout { codec =>  }
# }
#
class LogStash::Codecs::Gzip < LogStash::Codecs::Base

  # The codec name
  config_name "gzip"

  # The character encoding used in this codec. Examples include "UTF-8" and
  # "CP1252"
  #
  # JSON requires valid UTF-8 strings, but in some cases, software that
  # emits JSON does so in another encoding (nxlog, for example). In
  # weird cases like this, you can set the charset setting to the
  # actual encoding of the text and logstash will convert it for you.
  #
  # For nxlog users, you'll want to set this to "CP1252"
  config :charset, :validate => ::Encoding.name_list, :default => "UTF-8"

  def register
    # @lines = LogStash::Codecs::Line.new
    # @lines.charset = "UTF-8"
  end # def register

  def decode(data)
    gz = Zlib::GzipReader.new(StringIO.new(data.to_s))
    # uncompressed_string = gz.read
    yield LogStash::Event.new({
      "message" => gz.read
    })
    # @lines.decode(data) do |line|
    #   replace = { "message" => line.get("message").to_s + @append }
    #   yield LogStash::Event.new(replace)
    # end
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    event.get("message").to_s + @append + NL
  end # def encode_sync

end # class LogStash::Codecs::Gzip
