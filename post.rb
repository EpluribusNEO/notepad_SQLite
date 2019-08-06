
# Абстрактный Класс

class Post

  def self.post_type
    [Memo, Link, Task]
  end

  def self.create(type_index)
    return post_type[type_index].new
  end

  def initialize
    @created_at = Time.now # при создании записи, взять текущую дату
    @text = []#nil #массив строк --пуст
  end

  # Считать пользовательский ввод и записать в нужные поля
  def read_from_console
    # TODO --будет определено в подКлассах
    # подКлассах знают как считывать свои данные из консоли
  end

  # Метод возвращает состояние объекта в виде массива строк, готовых к записи в файл
  def to_strings
    #TODO --будет определено в подКлассах
    # подКлассах лучше знают как хранить свои данные в файле
  end

  # Метод записывает текущее состояние объекта в файл
  def save
    file = File.new(file_path, "w:UTF-8")

    for item in to_strings do
      file.puts(item)
    end

    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S")

    return "#{current_path}/mydox/#{file_name}.txt"
  end

  # ---------------------------------------------------------------------------
  def get_time_string
    "[Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}] \n\r\n\r"
  end
end