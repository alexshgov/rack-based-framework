require_relative 'advice'

class App
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      template = File.read("views/index.erb")
      content = ERB.new(template)
      ['200', {"Content-Type" => 'text/html'}, [erb(:index)]]
    when '/advice'
      ['200',
        {"Content-Type" => 'text/html'},
        [erb(:advice, message: Advice.new.sample)]
      ]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '51'},
        [erb(:not_found)]
      ]
    end
  end

  private

  def erb(filename, local = {})
    message = local[:message]
    b = binding
    path = File.expand_path("../views/#{filename}.erb", __FILE__)
    content = File.read(path)
    ERB.new(content).result(b)
  end
end
