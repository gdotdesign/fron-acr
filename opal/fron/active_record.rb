require 'opal'
require 'fron'
require 'fron/active_record/manager'
require 'fron/active_record/record'
require 'fron/active_record/models'

Fron::ActiveRecord::Manager.endpoint = DOM::Element.new(`Array.prototype.slice.call(document.getElementsByTagName("script"))`.last)[:src].split('/')[0..2].join('/')
