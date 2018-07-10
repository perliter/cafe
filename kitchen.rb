#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
begin
    print cgi.header("text/html; charset=utf-8")
    print "<html><body>"

    served_lines = cgi.params["served"] #提供済の行番号を取得、1行目はヘッダ
    kitchen_data = CSV.read('kitchen.csv', headers: true, encoding: "utf-8")
    #ファイル消去
    f=open('kitchen.csv','w:utf-8')
    f.close
    tableform = ""
    register_data = CSV.read('register.csv', encoding: "utf-8")
    kitchen_data.each_with_index do |line, i|
        if i == 0 || served_lines.include?(i) == false then
            f=CSV.open('kitchen.csv', 'a+:UTF-8')
                f.puts line
            f.close

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
        else
            line.each_with_index do |ele, j|
                register_data[line[0].to_i][j-1].to_i += ele.to_i unless i == 0
            end
        end
    end
    f=CSV.open('register.csv', 'a+:UTF-8')
        f.puts register_data
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

 