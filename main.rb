# frozen_string_literal: true

require 'json'
require './utils/file_operations.rb'

config = IO.read('config.json')
json = JSON.parse(config)

project_path = "#{json['tomcat']}/webapps/#{json['project']}"
view_path = "#{project_path}#{json['view_target']}"
lib_path = "#{project_path}#{json['lib_target']}"

puts project_path
puts view_path
puts lib_path

puts '**************************************部署jar包*********************************************'
fo = FileOperator.new
jar_files = fo.get_files_by_rule(json['lib_src'])
fo.copy_files_to_dir(jar_files, lib_path)

puts '**************************************部署views********************************************'
fo.copy_dir(json['view_src'], view_path)
