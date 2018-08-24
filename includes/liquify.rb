# require 'liquid'
# require 'yaml'
# @author Nathan Sheffield
# liquify takes a liquid template file and a yaml data file and populates the 
# template with data from the yaml file, into the provided outfile.

# @template = Liquid::Template.parse("hi {{name}}")
# @template.render('name' => 'tobi')

require 'liquid'
require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: liquify [options]"

  opts.on('-t', '--template TEMPLATE', 'Liquid template file') { |v| options[:template] = v }
  opts.on('-d', '--data DATA', 'YAML data file') { |v| options[:data] = v }
  opts.on('-o', '--outfile OUTFILE', 'Output file') { |v| options[:outfile] = v }

end.parse!
data = YAML.load_file(options[:data])
@template = Liquid::Template.parse(File.read(options[:template]))
File.write(options[:outfile], @template.render(data))

# data = YAML.load_file('/home/nsheff/code/cv/src/collaborators.yaml')
# puts thing.inspect
# @template = Liquid::Template.parse(File.read("/home/nsheff/code/cv/src/cv_uva_som.liquid"))
# File.write('populated.md', @template.render(thing))
