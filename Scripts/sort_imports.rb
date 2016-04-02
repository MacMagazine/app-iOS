#! /usr/bin/env ruby
# encoding: utf-8

require 'pathname'

def sorted_modules(file)
	module_import_regex = /^[ \t]*\@import .*$/

	module_imports = []
	matches = []

	file.scan(module_import_regex) do |match|
		matches.push Regexp.last_match
		module_imports.push match.strip
	end
	module_imports.sort_by!(&:downcase)
	module_imports.uniq!

	[module_imports, matches]
end

def sorted_lib_imports(file)
	lib_import_regex = /^[ \t]*\#import <.*$/

	lib_imports = []
	matches = []

	file.scan(lib_import_regex) do |match|
		matches.push Regexp.last_match
		lib_imports.push match.strip
	end
	lib_imports.sort_by!(&:downcase)
	lib_imports.uniq!

	[lib_imports, matches]
end

def sorted_regular_imports(file, file_name)
	import_regex = /^[ \t]*#import \".*$/

	imports = []
	matches = []

	file.scan(import_regex) do |match|
		matches.push Regexp.last_match
		imports.push match.strip
	end
	imports.sort_by!(&:downcase)
	imports.uniq!

	if file_name.end_with? ".m"
		header_parts = file_name.split(File::SEPARATOR).last.split('.')
		header_parts[-1] = 'h'
		header_name = header_parts.join '.'

		idx = imports.index "\#import \"#{header_name}\""
		if idx
			import = imports.delete_at idx
			imports.unshift import
		end
	end

	[imports, matches]
end

ARGV.each do |a|
	text = File.read(a)
	original_text = text.dup

	file_name = File.basename(Pathname a)
	modules, modules_matches = sorted_modules text
	libs, libs_matches = sorted_lib_imports text
	regular, regular_matches = sorted_regular_imports(text, file_name)

	all_matches = [modules_matches, libs_matches, regular_matches].flatten

	if all_matches.length > 0
		formatted_output = [modules, libs, regular].reject(&:empty?).map { |a| a.join "\n" }.join "\n\n"
		start = all_matches.map { |m| m.begin(0) }.min
		last  = all_matches.map { |m| m.end(0) }.max
		length = last - start

		text[start, length] = formatted_output
		if original_text != text
		  File.open(a, "w") { |file| file.puts text }
		end
	end
end
