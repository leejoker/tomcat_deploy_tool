# frozen_string_literal: string

require 'fileutils'

# file operations for copy files or handle path
class FileOperator
  # get the absolute paths from the mather
  def get_files_by_rule(path_rule)
    Dir.glob(path_rule)
  end

  def copy_files_to_dir(src_files, dest_dir)
    src_files.each do |file|
      file_name = File.basename(file)
      puts "copy [#{file}] to [#{dest_dir}/#{file_name}]"
      FileUtils.cp file, dest_dir + '/' + file_name
    end
  end

  def copy_dir(src, dest)
    puts "copy [#{src}] to [#{dest}]"
    FileUtils.cp_r src, dest
  end
end
