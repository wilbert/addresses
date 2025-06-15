# frozen_string_literal: true

module Addresses
  module CompressionUtils
    class << self
      def decompress_if_needed(file_path)
        return file_path unless file_path.end_with?('.zst')
        
        decompressed_path = file_path.chomp('.zst')
        
        unless File.exist?(decompressed_path) && File.mtime(decompressed_path) >= File.mtime(file_path)
          puts "Decompressing #{File.basename(file_path)}..."
          # Don't remove the .zst file after decompression
          system("zstd -d -f #{file_path.shellescape}") || raise("Failed to decompress #{file_path}")
        end
        
        decompressed_path
      end
      
      def compress_file(file_path, keep_original: false)
        return if file_path.end_with?('.zst')
        
        compressed_path = "#{file_path}.zst"
        puts "Compressing #{File.basename(file_path)}..."
        # Always keep the original file, we'll handle cleanup separately if needed
        system("zstd -9 -f #{file_path.shellescape}") || 
          raise("Failed to compress #{file_path}")
        
        compressed_path
      end
      
      # Clean up decompressed CSV files
      def cleanup_decompressed(file_path)
        return unless file_path.end_with?('.csv')
        return unless File.exist?(file_path)
        
        puts "Cleaning up decompressed file: #{File.basename(file_path)}"
        FileUtils.rm_f(file_path)
      end
    end
  end
end
