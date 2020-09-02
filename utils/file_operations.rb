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

  def create_metadata
    file = File.new('metadata', 'w+')
    file.puts('# time metadata')
    file.close
  end

  def get_metadata_value(key)
    lines = IO.readlines('metadata')
    lines.shift
    lines.each do |line|
      if line.include?(key)
        value_array = line.split('=')
        return value_array[1]
      end
    end
    nil
  end

  def write_metadata_value(hash_value)
    line_array = []
    lines = IO.readlines('metadata')
    update_by_hash(lines, hash_value, line_array)
    unless hash_value.empty?
      hash_value.each do |key, value|
        line_array.push("#{key}=#{value}")
      end
    end
    write_lines_from_start('metadata', line_array)
  end

  def update_by_hash(lines, hash, line_array)
    lines.each do |line|
      value_array = line.split('=')
      line = "#{value_array[0]}=#{hash[value_array[0]]}" unless hash[value_array[0]].nil?
      line_array.push(line)
      hash.delete(value_array[0])
    end
  end

  def write_lines_from_start(file, lines)
    f = File.open(file, 'w+')
    lines.each do |line|
      f.puts line
    end
    f.close
  end
end
