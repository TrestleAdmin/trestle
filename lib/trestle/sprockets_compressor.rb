module Trestle
  class SprocketsCompressor
    def initialize(original_compressor, excluded_files: ["trestle/admin"])
      @original_compressor = original_compressor
      @excluded_files = excluded_files
    end

    def call(input)
      if @excluded_files.include?(input[:name])
        input[:data]
      else
        @original_compressor.call(input)
      end
    end
  end
end
