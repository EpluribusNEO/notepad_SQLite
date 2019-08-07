class Link < Post

  def initialize
    super
    @url = ''
  end

  def read_from_console
    puts "Адрес ссылки:"
    @url = STDIN.gets.chomp

    puts "Описании ссылки:"
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = self.get_time_string#"Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r\n\r"

    return [time_string, @url, @text]
  end

  # Переопределение метода Супер-класса
  def to_db_hash
    return super.merge(
                    {
                        'text' => @text,
                        'url' => @url
                    }
    )
  end

  def load_data(data_hash)
    super(data_hash)
    @url = data_hash['url']
    @text = data_hash['text']
  end
end