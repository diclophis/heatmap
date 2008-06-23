#!/usr/bin/ruby

require ENV['COMP_ROOT'] + "/heatmap"
require ENV['COMP_ROOT'] + "/boot"

Rack::Handler::FastCGI.run(Heatmap)
