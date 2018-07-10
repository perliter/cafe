#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new

arr = Array.new()
arr << cgi["desk_num"]
arr += cgi.params["num"]
arr << cgi["memo"]
arr << cgi["num_of_masters"]

f=CSV.open('kitchen.csv', 'a+:UTF-8')
    f.puts arr
f.close

print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
    <form action="./take-order.rb">
        <p style="font-size:50px;">
            送信が完了しました。
            <input type="submit" value="注文を取るページに戻る" style="width:80%; height:10%; font-size:100%">
        <\p>
    </form>
</body></html>
EOF

