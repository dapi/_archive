class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.references :link, :company, :storage
      t.string :name       # организация
      t.string :address    # адрес
      t.string :phones     # телефон
      t.string :email      # email организации
      t.string :site_url   # сайт организации
      t.string :category   # категория (текст)
      t.string :work_time  # время работы организации
      t.text   :other_info # примечания (сюда попадает вся информация, что не попала в другие поля)

      t.text    :raw_html   # исходный текст (оригинальный текст на сайте)
      t.string  :http_last_modify # дата и время страницы (http last-modify)

      t.boolean :is_checked, :default => true # устанавливается совместно с is_updated если данная запись больше не обнаружена в источнике.
      t.boolean :is_updated, :default => true # обновилось или нет (устанавливается в случае, если эта запись изменила какую либо информацию после последней проверки. При создании новой записи устанавливается в true)
      t.boolean :is_removed # устанавливается совместно с is_updated если данная запись больше не обнаружена в источнике.

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
