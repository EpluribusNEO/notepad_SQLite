if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'task.rb'
require_relative 'memo.rb'

puts "Блокнот SQLite"
puts "Что записать:"

choices = Post.post_type.keys

choice = -1

until choice >=0 && choice < choices.size

  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  print "::>>>"
  choice = STDIN.gets.chomp.to_i
end

entry = Post.create(choices[choice])
entry.read_from_console
id = entry.save_to_db

puts "запись #{id} сохратена"