def input_check
  abort('mkdir: missing input') if ARGV.empty?
end

def folder_name
  ARGV.first
end

def source
  ["source 'https://rubygems.org'", "ruby '2.7.4'"]
end

def gems
  ["gem 'bundler'", "gem 'rspec'", "gem 'rubocop'", "gem 'rubocop-rspec'", "gem 'solargraph'"]
end

def extra_gems
  ARGV[1..].map { |gem| "gem '#{gem}'" }
end

def gemfile
  all_gems = []
  gems.map { |gem| all_gems << gem }
  extra_gems.map { |extra| all_gems << extra }
  [source, all_gems.sort].join("\n")
end

def create_folder(name)
  Dir.mkdir(name)
end

def change_folder(name)
  Dir.chdir(name)
end

def create_gemfile
  system('touch Gemfile')
  File.write('Gemfile', gemfile)
end

def app
  app = []
  app << "require 'bundler'"
  app << 'Bundler.require'
  app << ''
  app << "$LOAD_PATH.unshift File.expand_path('lib', __dir__)"
  app.join("\n")
end

def create_app
  system('touch app.rb')
  File.write('app.rb', app)
end

def system_commands
  system('rspec --init')
  system('bundle install')
  system('git init')
  system('git add .')
end

def execute
  input_check
  create_folder(folder_name)
  change_folder(folder_name)
  create_folder('./lib')
  create_folder('./db')
  create_app
  create_gemfile
  system_commands
end

execute
