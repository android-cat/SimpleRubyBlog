# app/models/application_record.rb
# 全てのモデルの基底クラス

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
