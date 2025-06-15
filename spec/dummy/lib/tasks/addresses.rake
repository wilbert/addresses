# Load all tasks from the main gem
Dir[File.expand_path('../../../../../lib/tasks/**/*.rake', __dir__)].each { |f| load f }
