#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require 'matrix'
require './def'
cgi = CGI.new
begin
    print cgi.header("text/html; charset=utf-8")
    print "<html><body>"

    served_lines = cgi.params["served"] #提供済の行番号を取得
    kitchen_data = CSV.read('kitchen.csv', encoding: "utf-8")
    menu_data = CSV.read('MenuData.csv', encoding: "utf-8")
    menu_name = menu_data[0].to_a + ["memo"]
    #ヘッダを書いてファイル初期化
    f=CSV.open('kitchen.csv','w:utf-8')
#        f.puts menu_name
    f.close
#    kitchen_data.delete_at(0)

    tableform = ""
    register_data = CSV.read('register.csv', encoding: "utf-8")
    kitchen_data.each_with_index do |line, i|
        if served_lines.include?(i.to_s) == false then
            f=CSV.open('kitchen.csv', 'a+:UTF-8')
                f.puts line.to_a
            f.close
            
            line.each_with_index do |value, j|
                case j
                    #最初
                    when 0 then tableform += <<-EOS
                        <div style="display:table-cell; border:1px solid #666">
                            <table border="1">
                                <tr><th>卓番号</th><th>#{value}</th></tr>
                        EOS
                    #最後
                    when line.size-1 then tableform += <<-EOS
                                <tr> <td>提供済み</td> <td><input type="checkbox" name="served" value="#{i}"></td> </tr>
                            </table>
                        </div>
                        EOS
                    #真ん中
                    else
                        value = 0 if value == nil 
                        tableform += "<tr><td>#{menu_name[j-1]}</td><td>#{value}</td></tr>" unless value.to_i == 0
                end
            end
        else
            #既存注文(なければ全要素0)に追加注文されて提供し終えたものを加算
            line_num = line[0].to_i - 1
            line.delete_at(0)
#            register_data[line_num] = (Vector[*register_data[line_num]] + Vector[*line.to_a]).to_a
            line.each_with_index do |value, j|
                if value =~ /^[0-9]+$/ then
                    value = value.to_i
                    register_data[line_num][j] = register_data[line_num][j].to_i
                end
                register_data[line_num][j] += value
            end
        end
    end
    f=CSV.open('register.csv', 'w:UTF-8')
        register_data.each do |row|
            f.puts row
        end
    f.close
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

 