# frozen_string_literal: true

gem 'paper_trail_manager_rails_6', path: __FILE__ + '/../../../'

unless File.exist?('app/assets/config/manifest.js')
  create_file 'app/assets/config/manifest.js'
  append_to_file 'app/assets/config/manifest.js', "//= link application.css\n"
  append_to_file 'app/assets/config/manifest.js', "//= link application.js\n"
end

generate 'paper_trail:install'
generate 'resource', 'entity name:string status:string --no-controller-specs --no-helper-specs'
generate 'resource', 'platform name:string status:string --no-controller-specs --no-helper-specs'

remove_file 'spec/models/entity_spec.rb'
remove_file 'spec/models/platform_spec.rb'

model_body = <<-MODEL
  has_paper_trail

  validates_presence_of :name
  validates_presence_of :status
MODEL

inject_into_class 'app/models/entity.rb', 'Entity', model_body
inject_into_class 'app/models/platform.rb', 'Platform', model_body

route "resources :changes, :controller => 'paper_trail_manager/changes'"

rake 'db:migrate db:test:prepare'
