# frozen_string_literal: true

module Addresses
  module CompressionUtils
    class << self
      def decompress_if_needed(file_path)
        return file_path unless file_path.end_with?('.zst')
        
        decompressed_path = file_path.chomp('.zst')
        
        unless File.exist?(decompressed_path) && File.mtime(decompressed_path) >= File.mtime(file_path)
          puts "Decompressing #{File.basename(file_path)}..."
          system("zstd -d --rm -f #{file_path.shellescape}") || raise("Failed to decompress #{file_path}")
        end
        
        decompressed_path
      end
      
      def compress_file(file_path, keep_original: false)
        return if file_path.end_with?('.zst')
        
        compressed_path = "#{file_path}.zst"
        puts "Compressing #{File.basename(file_path)}..."
        keep_flag = keep_original ? '' : '--rm'
        system("zstd -9 --rm=#{keep_original ? 'never' : 'dest'} -f #{file_path.shellescape}") || 
          raise("Failed to compress #{file_path}")
        
        compressed_path
      end
    end
  end
end
