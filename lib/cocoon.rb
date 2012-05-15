require 'cocoon/view_helpers'

module Cocoon
  class Engine < ::Rails::Engine

    config.before_initialize do
      config.action_view.javascript_expansions[:cocoon] = %w(cocoon)
    end

    # configure our plugin on boot
    initializer "cocoon.initialize" do |app|
      ActionView::Base.send :include, Cocoon::ViewHelpers
    end

    # Monkey-patch DM with AR `collection?` method
    config.after_initialize do
      if defined? DataMapper::Associations
        class DataMapper::Associations::OneToMany::Relationship
          def collection?
            true
          end
        end
        class DataMapper::Associations::OneToOne::Relationship
          def collection?
            false
          end
        end
        class DataMapper::Associations::ManyToMany::Relationship
          def collection?
            true
          end
        end
        class DataMapper::Associations::ManyToOne::Relationship
          def collection?
            false
          end
        end
      end
    end

  end
end
