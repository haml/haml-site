# Preview server: renders pages and stylesheets on demand, and falls back to the
# files already built into site/. Start it with `rake preview`.
require 'rack'
require_relative 'config/boot'

site  = HamlSite.staticmatic
files = Rack::Files.new(site.site_dir)

use Rack::ShowExceptions

run lambda { |env|
  site.load_helpers

  path  = Rack::Utils.unescape(env['PATH_INFO'])
  path  = File.join(path, 'index.html') if path.end_with?('/')
  path += '.html' if File.extname(path).empty?

  dir, base = File.split(path)
  ext  = File.extname(base).delete_prefix('.')
  name = File.basename(base, '.*')
  dir  = dir.sub(%r{^/stylesheets/?}, '')

  # Partials (_footer and friends) are never served on their own.
  renderable = %w[html css].include?(ext) &&
               site.template_exists?(name, dir) &&
               !name.start_with?('_')
  next files.call(env) unless renderable

  begin
    body = ext == 'css' ? site.generate_css(name, dir) : site.generate_html_with_layout(name, dir)
    [200, { 'content-type' => "text/#{ext}; charset=utf-8", 'cache-control' => 'no-store' }, [body]]
  rescue StaticMatic::Error => e
    [500, { 'content-type' => 'text/plain; charset=utf-8' }, [e.message]]
  end
}
