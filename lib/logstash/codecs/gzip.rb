# encoding: utf-8
require 'zlib'
require 'stringio'

require "logstash/codecs/base"
require "logstash/util/charset"
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

  def initialize(params={})
    super(params)
    @converter = LogStash::Util::Charset.new(@charset)
    @converter.logger = @logger
  end

  def decode(data)
    begin
      gz = Zlib::GzipReader.new(StringIO.new(data.to_s))

      yield LogStash::Event.new({
        "message" => @converter.convert(gz.read)
      })
    rescue Zlib::Error => e
      @logger.error("Gzip codec: We cannot uncompress the gzip data")
      raise e
    end
  end # def decode

  # Encode a single event, this returns the raw data to be returned as a String
  def encode_sync(event)
    begin
      gz = Zlib::GzipWriter.new(StringIO.new)
      gz << @converter.convert(event.get("message").to_s)
      gz.close.string
    rescue Zlib::Error => e
      @logger.error("Gzip codec: We cannot compress the gzip data")
      raise e
    end
  end # def encode_sync

end # class LogStash::Codecs::Gzip
