#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")

begin
num_of_desk = cgi["num_of_desk"]
names=cgi.params["menu"]
names.delete("")
prices=cgi.params["price"]
prices.delete("")

f=CSV.open('MenuData.csv', 'w:UTF-8')
    f.puts names
    f.puts prices
f.close

=begin
kitchen_data = ["desk_of_num"]
kitchen_data += names
kitchen_data += ["memo", "NumOfPeople"]
f=CSV.open('kitchen.csv', 'w:UTF-8')
    f.puts kitchen_data
f.close
=end
register_data = Array.new()
names.size.times do
    register_data << "0" 
end
register_data += ["memo", "0"]
f=CSV.open('register.csv', 'w:UTF-8')
    num_of_desk.to_i.times do
        f.puts register_data
    end
f.close
rescue
    error_cgi
end
print <<-EOF
<html><body>
    <a href="./kitchen.rb">kitchen</a>
</body></html>
EOF