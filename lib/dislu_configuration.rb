

class Spree::DisluConfiguration < Spree::Preferences::Configuration
  preference :import_row_from_title, :integer, default: 1
  preference :theme, :string, :default => "Default"
  preference :show_splash_page, :boolean
  preference :number_of_articles, :integer
end