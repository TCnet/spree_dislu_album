module SpreeDisluAlbum
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_dislu_album'

    

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

  
    #cause `has_many_attached' for #<Class:0x00007fe9cda26b38> (NoMethodError) 'error when use active_storage so remove

    config.autoload_paths += %W(#{config.root}/lib)
    #initializer 'spree.dislu_album.preferences', before: :load_config_initializers do
    #  Spree::DisluAlbum::Config = Spree::DisluAlbumSetting.new
    #end

    #config.autoload_paths += Dir["#{config.root}/lib"]

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)

    

  end
end
