
# Абстрактный Класс

require "sqlite3"

class Post

  @@SQLITE_DB_FILE = "notepad.sqlite" #--Переменная класса (Статическая)

  def self.post_type
    {'Memo' =>Memo, 'Link'=>Link, 'Task'=>Task}
  end

  def self.create(type)
    return post_type[type].new
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

  #============================================================================
  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) #--Открыть соединение к БД
    db.results_as_hash = true #Возвращять данные как АССАЦИАТИВНЫЕ_МАССИВЫ

    db.execute(
          "INSERT INTO posts(" +
              to_db_hash.keys.join(',') +
              ")" +
              " VALUES(" +
              ('?,' * to_db_hash.keys.size).chomp(',') +
              ")",
              to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close
    return insert_row_id
  end

  # Абстрактный метод.Вернёт Ассоциативный массив со всеми параметрами.
  # Переопределяется в дочерних классах. Будут добавлены данные в Хэш.
  def to_db_hash
    {
        'type' => self.class.name,
        'created_at' => @created_at.to_s
    }
  end

end