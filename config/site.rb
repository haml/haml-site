require 'compass'
require 'cgi'

Compass.configuration do |config|
  # project_path should be the the directory to which the sass directory is relative.
  # I think maybe this should be one more directory up from the configuration file.
  # Please update this if it is or remove this message if it can stay the way it is.
  config.project_path = File.dirname(__FILE__)
  config.sass_dir = File.join('src', 'stylesheets' )
end

module StaticMatic::Helpers
  def local_page
    current_page.gsub(/\.html$/, '').gsub(/\/index$/, '').gsub(/^\//, '')
  end

  def css
    (["Haml"] + local_page.capitalize.split(File::SEPARATOR)).join(" :: ")
  end

  def h_and_preserve(content = nil, &block)
    return preserve(CGI.escapeHTML(content)) if content
    return h_and_preserve(capture_haml(&block).strip)
  end
end
