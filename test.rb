#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
begin
    print cgi.header("text/html; charset=utf-8")
    print "<html><body>"
    
    kitchen_data = CSV.read('kitchen.csv', headers: true, encoding: "utf-8")
    arr = Array.new
    kitchen_data[0].to_h.each_key do |key|
        arr << key
    end
    print arr
rescue
    error_cgi
end
print "</body></html>"
