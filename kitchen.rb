#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
begin
    kitchen_data = CSV.read('kitchen.csv', encoding: "utf-8")
    register_data = CSV.read('register.csv', encoding: "utf-8")
    menu_names = CSV.read('MenuData.csv', encoding: "utf-8")[0].to_a + ["memo"]
 
    tableform = ""#html書き込み用
    f=CSV.open('kitchen.csv','w:utf-8')
        kitchen_data.each_with_index do |line, i|
            if cgi.params["served"].include?(i.to_s) then
            #処理する行が提供済み注文行と一致していれば、既存注文(なければ全要素0)に提供し終えたものを加算
                #卓番号を基準にした＆要素数合わせ
                desk_num = line[0].to_i - 1; line.delete_at(0)

                #要素足し合わせ、足したいものが数値かを正規表現で判定して数値ならto_i
                line.each_with_index do |value, j|
                    if value =~ /^[0-9]+$/ then
                        value = value.to_i
                        register_data[desk_num][j] = register_data[desk_num][j].to_i
                    end
                    register_data[desk_num][j] += value
                end
            else
            #不一致なら再書き込み＆表示の準備
                f.puts line.to_a
            
                line.each_with_index do |value, j|
                    if (value != "" && value != "0") || j == line.size-1 then
                    #人数以外のvalueが空じゃないならそれに応じてhtml生成
                        tableform += case j
                            #最初(卓番号)
                            when 0; <<-EOS
                                <div style="display:table-cell; border:1px solid #666">
                                    <table border="1">
                                        <tr><th>卓番号</th><th>#{value}</th></tr>
                                EOS
                            #最後(提供済み)
                            when line.size-1; <<-EOS
                                        <tr> <td>提供済み</td> <td><input type="checkbox" name="served" value="#{i}"></td> </tr>
                                    </table>
                                </div>
                                EOS
                            #真ん中(注文とmemo)
                            else "<tr><td>#{menu_names[j-1]}</td><td>#{value}</td></tr>" 
                        end
                    end
                end
            end
        end
    f.close
    #提供済みのものが加算された結果をregister.csvに書き込み
    f=CSV.open('register.csv', 'w:UTF-8')
        register_data.each do |row|
            f.puts row
        end
    f.close
rescue
    error_cgi
end 
print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
    <form name="update" action="./kitchen.rb" method="post">
        <div style="display:table; ">
            #{tableform}
        </div>
        <input type="submit" value="更新">
    </form>
</body></html>
EOF
 