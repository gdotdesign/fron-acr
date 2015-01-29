require 'opal'
require 'fron'
require 'fron/active_record/manager'
require 'fron/active_record/record'
require 'fron/active_record/models'

src = DOM::Element.new(`Array.prototype.slice.call(document.getElementsByTagName("script"))`.last)[:src]
Fron::ActiveRecord::Manager.endpoint = src.split('/')[0..2].join('/') if src =~ /^http/
