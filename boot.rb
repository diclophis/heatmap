#JonBardin

$appver = '0.1'
$appname = 'heatmap'
$appid = "#{$appname} v#{$appver}"
$apphost = '[127.0.0.1]'

Camping::Models::Base.logger = Logger.new('/var/log/heatmap.log')

ENV['PATH'] = '/usr/bin'
ENV['COMP_ROOT'] = '/var/www/heatmap'
