#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")

unless cgi["desk_num"] == "" then
    desk_num = cgi["desk_num"].to_i - 1
    register_data = CSV.read('register.csv', encoding: "utf-8")
    register_data[desk_num].each_with_index do |value, i|
        if value =~ /^[0-9]+$/ then
           register_data[desk_num][i] = 0
        else   
            register_data[desk_num][i] = "memo"
        end
    end
    f=CSV.open('register.csv', 'w+:utf-8')
        register_data.each do |row|
            puts row
        end
    f.close
end

print <<EOF
<html><body>
    <form name="gotomain" action="./register-main.rb" method="post">
        <input type="textbox" name="desk_num" placeholder="卓番号を[半角]数字で入力">
        <input type="submit" value="会計">
    </form>
</body></html>
EOF
