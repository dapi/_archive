class CreateStorages < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
      t.string :name       # организация
      t.string :address
      t.string :phones     # телефон
      t.string :email      # email организации
      t.string :site_url   # сайт организации
      t.string :category   # категория (текст)
      t.string :work_time  # время работы организации
      t.text :other_info # примечания (сюда попадает вся информация, что не попала в другие поля)

      t.timestamps
    end
  end

  def self.down
    drop_table :storages
  end
end
