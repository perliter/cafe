#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
print "<html><body>"
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
    tableform = ""
    kitchen_data = CSV.read('kitchen.csv', headers: true, encoding: "utf-8")
    kitchen_data.each_with_index do |line, i|
        line.each do |key, value|
            case
                #最初
                when key == "desk_num" then print <<-EOS
                    <div style="display:table-cell; border:1px solid #666">
                        <table border="1">
                            <tr><th>卓番号</th><th>#{line["desk_num"][value]}</th></tr>
                    EOS
                #最後
                when key == "NumOfPeople" then print <<-EOS
                            <tr> <td>提供済み</td> <td><input type="checkbox" name="served" value="#{line["desk_num"][i]}"></td> </tr>
                        </table>
                    </div>
                    EOS
                #真ん中
                when value != "0" then print "<tr><td>#{key}</td><td>#{value}</td></tr>" unless value == nil
            end
        end
    end
=begin
        tableform += <<-EOS
            <div style="display:table-cell; border:1px solid #666">
                <table border="1">
                    <tr><th>席番号</th><th>#{kitchen_data[0]["desk_num"]}</th></tr>
        EOS
        line.each do |key, value|
            if value != "0" && key != "desk_num" then
                tableform += <<-EOS
                    <tr><td>#{key}</td><td>#{value}</td></tr>
                EOS
            end
        end
        tableform += <<-EOS
                    <tr> <td>提供済み</td> <td><input type="checkbox" name="served" value="#{kitchen_data[0]["desk_num"]}"></td> </tr>
                </table>
            </div>
        EOS
    end

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
=end
rescue
    error_cgi
end 
print <<EOF
    <form name="update" action="./kitchen.rb" method="post">
        <div style="display:table; ">
        #{tableform}
        </div>
        <input type="submit" value="更新">
    </form>
    </body></html>
EOF

 