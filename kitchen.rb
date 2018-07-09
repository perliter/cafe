#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require './def'
cgi = CGI.new

def plus_each_ele(filename_to_write, *arr)
    temp = read_file_line(filename_to_write)
    f=open(filename_to_write, "w:UTF-8")
        temp.each_with_index{ |item, i| f.write((item.to_i + arr[i].to_i).to_s+"\n")}
    f.close
end

def zeroize(filename)
    f=open(filename, "w:UTF-8")
        11.times do
            f.write("0\n")
        end
    f.close
end
begin

served = cgi.params["served"]

desk_nums_serving = read_file_line("serving")
#desk_num_serivingから提供済みのものをserving無しに移してservingから削除する準備
served.each{ |desk_num_served|
    temp = read_file_line("#{desk_num_served}_serving")
    plus_each_ele(desk_num_served, *temp)
    zeroize("#{desk_num_served}_serving")
    desk_nums_serving.delete(desk_num_served)
}
f=open("serving", "w:UTF-8")
    desk_nums_serving.each{ |item|
        f.write("#{item}\n")#実際に削除(除いたもので上書き)
    }
f.close

menu_name = read_file_line("MenuName.txt")
tableform = ""
desk_nums_serving.each{ |desk_num|
    quantity = read_file_line("#{desk_num}_serving")
    quantity.delete_at(0)#「人数」を除外

    tableform << "<div style=\"display:table-cell; border:1px solid #666\"><table border=\"1\"><tr><th>席番号</th><th>#{desk_num}</th></tr>"
    quantity.each_with_index{ |item, i|
        tableform << "<tr><td>#{menu_name[i]}</td><td>#{item}</td></tr>"
    }
    tableform << "<tr><td>提供済み</td><td><input type=\"checkbox\" name=\"served\" value=\"#{desk_num}\"></td></tr></table></div>"
}
rescue
    error_cgi
end 
print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
    <form name="update" action="./hq.rb" method="post">
        <div style="display:table; ">
        #{tableform}
        </div>
        <input type="submit" value="更新">
    </form>
    </body></html>
EOF

 