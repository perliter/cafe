#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
cgi = CGI.new

def read_file_line(filename)
    arr=[]
    f=open(filename, "r+:UTF-8")
        while line = f.gets
            arr << line.chomp
        end
    f.close
    return arr
end
def zeroize(filename)
    temp=read_file_line("MenuName.txt")
    f=open(filename, "w:UTF-8")
        (temp.size+1).times do
            f.write("0\n")
        end
    f.close
end

unless cgi["desk_num"]==nil then
    zeroize(cgi["desk_num"])
end

print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
    <form name="gotomain" action="./register-main.rb" method="post">
        <input type="textbox" name="desk_num" placeholder="卓番号を[半角]数字で入力">
        <input type="submit" value="会計">
    </form>
</body></html>
EOF