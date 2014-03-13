module Jim
  class Engine < ::Rails::Engine
    isolate_namespace Jim

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'activeservice.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths << Jim::Engine.root.join("lib")
    end
  end
end
