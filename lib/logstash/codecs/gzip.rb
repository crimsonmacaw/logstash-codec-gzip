# encoding: utf-8
require 'zlib'
require 'stringio'

require "logstash/codecs/base"
require "logstash/namespace"

# This codec will decompress incoming gzip data or gzip compress
# outgoing data
#
# input {
#   stdin { codec => gzip }
# }
#
# or
#
# output {
#   stdout { codec => gzip }
# }
#
class LogStash::Codecs::Gzip < LogStash::Codecs::Base

  # The codec name
  config_name "gzip"

  def register
  end # def register

  def decode(data)
    gz = Zlib::GzipReader.new(StringIO.new(data.to_s))

    yield LogStash::Event.new({
      "message" => gz.read
    })
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    gz = Zlib::GzipWriter.new(StringIO.new)
    gz << event.get("message").to_s
    gz.close.string
  end # def encode_sync

end # class LogStash::Codecs::Gzip
