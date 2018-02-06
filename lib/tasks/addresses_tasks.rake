# encoding: utf-8

desc "Addresses rake"
task :addresses do
  Rake::Task["populate_countries"].invoke
  Rake::Task["populate_states"].invoke
  Rake::Task["populate_cities"].invoke
  Rake::Task["populate_neighborhoods"].invoke
end
