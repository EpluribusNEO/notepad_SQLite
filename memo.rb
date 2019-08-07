class Memo < Post

  def read_from_console
    puts "Новая заметка (все что пишится до строки \"end\"):"

    @text = []
    line = nil

    while line != "end" do
      line = STDIN.gets.chomp
      @text << line
    end

    @text.pop
  end

  def to_strings
    time_string = self.get_time_string     #"Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)
  end

  def to_db_hash
    return super.merge(
        {
            'text' => @text.join('\n\r')
        }
    )
  end

  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text'].split('\n\r')
  end

end