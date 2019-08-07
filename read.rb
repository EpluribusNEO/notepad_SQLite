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


require 'optparse'


def line_format(args)
  str = format("|%5s| |%5s| |%25s| |%40s| |%20s| |%10s|",
                  args[0],args[1],args[2],args[3].gsub("\\n\\r"," ")[0..40],args[4].to_s[0..20],args[5])
  return str.to_s
end

#Пользовательские настройки...:
# Выгрузить запись по номеру (id)
# Произвести вугрузку определённого поличества записе1 (limit)
# Выгрузить запись определённого типа (type)
options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [option]'

  opt.on('--h', 'Prints this help') do
    puts opr
    exit
  end

  opt.on('--type POST_TYPE', 'Укажите тип записей (по-умолчанию все)') { |o| options[:type] = o}
  opt.on('--id POST_ID', 'укажите id записи') {|o| options[:id] = o}
  opt.on('--limit NUMBERS', 'Количество последнизх записей') {|o| options[:limit] = o}

end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

# если рузультат == Класс Post
if result.is_a? Post
  puts "Запись #{result.class.name}, id:#{options[:id]}"
  result.to_strings.each do |line|
    puts line
  end
else
  #вывод краткой сводки, того, что лежит в базе данных
  #print "| id\t| @type\t|  @created_at\t\t\t|  @text\t\t\t| @url\t\t| @deadlite_at \t "
  msg = ["id", "@type", "@created_at", "@text", "@url","@deadlite"]
  print line_format(msg)

  result.each do |row|
    puts
   # row.each do |element|
    #  print "| #{element.to_s.delete('')[0..40]}\t"
    #end
   #str = format("|%5s| |%5s| |%25s| |%40s| |%20s| |%10s|",
              #  row[0],row[1],row[2],row[3],row[4],row[5])
    print line_format(row)
  end
  puts "\n"
end


# --------------------------------------
