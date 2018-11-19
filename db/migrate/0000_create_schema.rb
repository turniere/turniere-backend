# frozen_string_literal: true

class CreateSchema < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Required
      t.string :provider, null: false, default: 'email', index: true
      t.string :uid, null: false, default: '', index: { unique: true }

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token, index: { unique: true }
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token, index: { unique: true }
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## User Info
      t.string :username, index: { unique: true }
      t.string :email, index: { unique: true }

      ## Tokens
      t.text :tokens

      t.timestamps
    end

    create_table :tournaments do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.string :description
      t.boolean :public, default: true

      # relation to owner
      t.belongs_to :user, index: true, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    create_table :stages do |t|
      t.integer :level

      t.belongs_to :tournament, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end

    create_table :groups do |t|
      t.integer :number

      t.belongs_to :stage, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end

    create_table :matches do |t|
      t.integer :state, default: 0

      t.belongs_to :stage, index: true, foreign_key: { on_delete: :cascade }
      t.belongs_to :group, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name

      t.belongs_to :tournament, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    create_table :scores do |t|
      t.integer :score, default: 0

      t.belongs_to :match, index: true, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :team, index: true, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    create_table :group_scores do |t|
      t.integer :score, default: 0
      t.integer :points_scored, default: 0
      t.integer :points_received, default: 0

      t.belongs_to :team, index: true, foreign_key: { on_delete: :cascade }, null: false
      t.belongs_to :group, index: true, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
