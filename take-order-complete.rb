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
def plus_each_ele(filename_to_write, *arr)
    temp = read_file_line(filename_to_write)
    f=open(filename_to_write, "w:UTF-8")
        temp.each_with_index{ |item, i| f.write((item.to_i + arr[i].to_i).to_s+"\n")}
    f.close
end
def error_cgi
	print "Content-Type:text/html;charset=EUC\n\n"
	print "*** CGI Error List ***<br />"
	print "#{CGI.escapeHTML($!.inspect)}<br />"
	$@.each {|x| print CGI.escapeHTML(x), "<br />"}
end
begin
desk_num = cgi["desk_num"]
nums = cgi.params["num"]

#処理中の注文を卓番号で管理
f=open("serving", "a+:UTF-8")
    f.write("#{desk_num}\n")
f.close

#注文を書き込み
plus_each_ele("#{desk_num}_serving", *nums)
rescue
    error_cgi
end 
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

