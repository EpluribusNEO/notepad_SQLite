require 'date'
class Task < Post
  def initialize
    super
    @due_date = Time.now
  end

  def read_from_console
    puts "Что надо сделать?"
    @text = STDIN.gets.chomp

    puts "к какому числу? Указать дату в формате ДД.ММ.ГГГГ, например (27.07.2007)"
    input = STDIN.gets.chomp
    if input == ""
      @due_date = Date.today
    else
      @due_date = Date.parse(input)
    end
  end

  def to_strings
    time_string = self.get_time_string  #"Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"
    deadline = "Дэдлайн: #{@due_date.strftime('%Y.%m.%d')}"
    return [time_string, @text, deadline]
  end

  # Переопределение метода Супер-класса
  def to_db_hash
    return super.merge(
                    {
                        'text' => @text,
                        'deadline_at' => @due_date.to_s
                    }
    )
  end
end
