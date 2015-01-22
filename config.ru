require 'fron/active_record/middleware'


app = Proc.new do |env|
    ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
end

map '/api.js' do
	use Fron::ActiveRecord::Middleware
end

run app
