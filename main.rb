# frozen_string_literal: true

require 'json'
require './utils/file_operations.rb'

config = IO.read('config.json')
json = JSON.parse(config)

project_path = "#{json['tomcat']}/webapps/#{json['project']}"
view_path = "#{project_path}#{json['view_target']}"
lib_path = "#{project_path}#{json['lib_target']}"

puts "project_path: [#{project_path}]"
puts "view_path: [#{view_path}]"
puts "lib_path: [#{lib_path}]"

# create metadata file
fo = FileOperator.new
exist = File.exist?('metadata')
fo.create_metadata unless exist

jar_files = fo.get_files_by_rule(json['lib_src'])

loop do
  update_array = []
  hash_array = {}
  jar_files.each do |file|
    file_name = File.basename(file, '.jar')
    time = fo.get_metadata_value(file_name)
    stat = File::Stat.new(file)
    mtime = stat.mtime.to_i
    unless time.nil?
      update_array.push(file) if mtime > time.to_i
    end
    hash_array[file_name] = stat.mtime.to_i
  end
  fo.write_metadata_value(hash_array)
  puts '**************************************部署jar包*********************************************'
  fo.copy_files_to_dir(update_array, lib_path)
  puts '**************************************部署views********************************************'
  fo.copy_dir(json['view_src'], view_path) unless update_array.empty?

  sleep 10
end
