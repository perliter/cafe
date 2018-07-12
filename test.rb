#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
begin
    print cgi.header("text/html; charset=utf-8")
    print "<html><body>"
    kitchen_data = CSV.read('kitchen.csv', encoding: "utf-8")
    
    arr = kitchen_data[0]
    print arr
rescue
    error_cgi
end
print "</body></html>"
