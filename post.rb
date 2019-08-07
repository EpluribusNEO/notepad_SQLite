
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

  def self.find(limit, type, id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)

    # Выгрузка по id
    if !id.nil?
      db.results_as_hash = true
      # ? --"ПлэйсХолдер". Вместо ? подставится id
      result = db.execute("SELECT * FROM posts WHERE post_id = ?", id)

      # execute возвращает Массивы
      # если результат массив, то в result запишеп первый элемент массива
      result = result[0] if result.is_a? Array

      db.close

      if result.empty?
        puts "Запись с id:#{id} не найдена"
        return nil
      else
        post = create(result['type'])
        post.load_data(result)

        return post
      end

    else
      #иначе вывести таблицу
      db.results_as_hash = false

      query = "SELECT * FROM posts "
      query += "WHERE type = :type " unless type.nil? # Выполнить если тип не пуст. :type -плэйсХолдер
      query += "ORDER BY post_id DESC " #Отсортировать по убываний, свежие записи вперёд...
      query +=  "LIMIT :limit " unless limit.nil? #лимит, сколько записей вернуть

      statement = db.prepare(query) #получает строку и готовит запрас к выполнению
                                    #statement объект готовый к выполнению
                                    #к объекту можно подключать параметры используя именнованные плэйсХолдеры

      #к подготовленному параметру выражения добавляем, аргументы ('имя_плэйсХолдера', аргумент)
      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute! # execute! вернёт массив результатов. Массив содержаий массивы с полями

      statement.close
      db.close

      return result
    end
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
    "[Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r\n\r"
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

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

  def delete_row_by_id(id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.execute("DELETE * FROM posts WHERE post_id = ?", id)
    db.close
  end

end
