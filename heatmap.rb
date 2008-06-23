#!/usr/bin/ruby
#JonBardin

require 'gserver'
require 'uri'
require 'ftools'
require 'rubygems'
require 'RMagick'
include Magick
require 'time'
require 'timeout'
require 'open3'
require 'redcloth'
require 'digest/md5'
require 'daemons'
require 'benchmark'
require 'ruby2ruby'
require 'drb'
require 'uuidtools'
require 'right_aws'

#import into the system
require 'camping'

Camping.goes :Heatmap

module Heatmap
end

module Heatmap::Controllers
  class Generate < R("/generate")
    def get
      created_image_file = false
      heatmap_id = Time.now.to_i
      dir = "/var/www/heatmap/public/heatmaps"
      name = "#{dir}/#{heatmap_id}.png"
      IO.popen("-") { |worker|
        unless worker
          Kernel.srand
          max_x = 640
          max_y = 480
          points = Array.new
          conf = {
            'dotimage' => '/var/www/heatmap/public/images/bolilla.png',
            'colorimage' => '/var/www/heatmap/public/images/colors.png',
            'opacity' => "0.50",
            'dotwidth' => 64
          }
          max_x = max_x
          max_y = max_y
          halfwidth = conf['dotwidth'] / 2
          intensity = (100 - (100 / 1).ceil)
          images = Magick::ImageList.new
          colored_images = Magick::ImageList.new
          dots = images.new_image((max_x + halfwidth), (max_y + halfwidth))
          dot = Magick::Image.read(conf['dotimage']).first.colorize(intensity, intensity, intensity, "white")
          color = Magick::Image.read(conf['colorimage']).first
          500.times {
            x = Kernel.rand(max_x)
            y = Kernel.rand(max_y)
            dots.composite!(dot, ((x)-halfwidth),  ((y)-halfwidth), Magick::MultiplyCompositeOp)
          }
          (ImageList.new << (ImageList.new << dots.negate << color).fx("v.p{0,u*v.h}")).fx("0.25", ChannelType::AlphaChannel).write(name)
          created_image_file = name
        else
          created_image_file = true
        end
      }
      if created_image_file then
        FileUtils.ln_s(name, "/var/www/heatmap/public/heatmaps/latest.png", :force => true)
        "<html><body style=\"background:url(/images/stripe.gif)\"><img src=\"/heatmaps/#{heatmap_id}.png\"/></body></html>"
      end
    end
  end

  class Index < R("/")
    def get
      "<html><body style=\"background:url(/images/stripe.gif)\"><img src=\"/heatmaps/latest.png\"/></body></html>"
    end
  end
end

module Heatmap::Views
end
