require 'rubygems'
require 'bundler/setup'
require 'require_all'

Bundler.require(:default)
require_rel '../lib'
require_rel '../app'
