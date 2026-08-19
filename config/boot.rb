# Shared bootstrap for the two entry points that need StaticMatic: the Rakefile
# (build) and config.ru (preview server). Both must be run from the project root.

# StaticMatic requires 'rack/handler/webrick', which no longer exists. The stub
# that satisfies that require lives in the project root, so it has to be on the
# load path before staticmatic is required.
$LOAD_PATH.unshift(File.expand_path("..", __dir__))

if defined?(Encoding)
  Encoding.default_external = 'UTF-8'
  Encoding.default_internal = 'UTF-8'
end

# src/pages/_footer.haml calls Date.today
require 'date'

# Monkey-patching for compass 0.11.7 on Ruby 3.2+
unless File.respond_to? :exists?
  File.instance_eval { alias exists? exist? }
end

require '.haml/lib/haml'
require 'staticmatic'

# Monkey-patching for Haml 6 + StaticMatic
module StaticMaticRenderMixinMonkeyPatch
  def generate_html_from_template_source(source, options = {}, &block)
    options = options.dup
    locals  = options.delete(:locals) || {}
    options[:escape_html] = false
    template = Haml::Template.new(options) { source }
    template.render(@scope, locals, &block)
  end
end

if Haml::Engine.method(:initialize).arity == -1
  StaticMatic::Base.prepend StaticMaticRenderMixinMonkeyPatch
end

module HamlSite
  # Builds a StaticMatic instance configured from config/site.rb.
  #
  # The eval is deliberately given no filename: config/site.rb derives
  # project_path from File.dirname(__FILE__), which resolves to "." only while
  # __FILE__ is "(eval)". Naming the file there would point Compass at
  # config/src/stylesheets instead of src/stylesheets.
  def self.staticmatic
    configuration = StaticMatic::Configuration.new
    eval(File.read("config/site.rb"))
    StaticMatic::Base.new(".", configuration)
  end
end
