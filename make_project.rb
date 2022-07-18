def check_if_user_gave_input
  abort('mkdir: missing input') if ARGV.empty?
end

def folder_name
  ARGV.first
end

def source
  ["source 'https://rubygems.org'", "ruby '2.7.4'"]
end

def gems
  ["gem 'rspec'", "gem 'rubocop'", "gem 'rubocop-rspec'", "gem 'solargraph'"]
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

def execute
  check_if_user_gave_input
  create_folder(folder_name)
  change_folder(folder_name)
  create_folder('./lib')
  create_gemfile
  system('touch app.rb')
  system('rspec --init')
  system("cd #{folder_name}")
  system('bundle install')
end

execute
