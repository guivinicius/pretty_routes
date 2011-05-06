desc 'Pretty print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'

$terminal = %x(echo $TERM).strip!
$unsafe_methods_pattern = /(_id=|_ids=|_type=|admin=)$/

def puts_in_color(text, options = {})
  if $terminal == 'xterm-color'
    case options[:color]
    when :red
      puts "\033[31m#{text}\033[0m"
    when :green
      puts "\033[32m#{text}\033[0m"
    when :yellow
      puts "\033[33m#{text}\033[0m"  
    when :blue
      puts "\033[34m#{text}\033[0m"  
    else
      puts text
    end
  else
    puts text
  end
end

def green(text)
  puts_in_color text, :color => :green
end

def red(text)
  puts_in_color text, :color => :red
end

def blue(text)
  puts_in_color text, :color => :blue
end

def yellow(text)
  puts_in_color text, :color => :yellow
end

task :pretty_routes => :environment do
  all_routes = ENV['CONTROLLER'] ? ActionController::Routing::Routes.routes.select { |route| route.defaults[:controller] == ENV['CONTROLLER'] } : ActionController::Routing::Routes.routes
  
  routes = all_routes.collect do |route|
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    {:name => route.name, :verb => route.verb, :path => route.path, :reqs => reqs, :controller => route.defaults[:controller]}
  end
  
  routes.each do |r|
    green "#{r[:name]}"
    yellow "  #{r[:verb]} #{r[:path]}"
    yellow "  #{r[:reqs]}"
  end
  
end