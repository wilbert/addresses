# Load all tasks from the main gem
Dir[File.expand_path('../../../../../lib/addresses/tasks/**/*.rake', __dir__)].each { |f| load f }
