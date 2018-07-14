#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin

desk_num = cgi["desk_num"].to_i - 1
paid_line_nums = cgi.params["to_pay"]

register_data = CSV.read('register.csv', encoding: 'utf-8')
selected_register_data = register_data[desk_num].to_a

if paid_line_nums.size == 0 then
    f=CSV.open('orderlog.csv', 'a:utf-8')
        f.puts selected_register_data
    f.close
end

menu_data = CSV.read('MenuData.csv', encoding: "utf-8")
menu_names, menu_prices = menu_data[0].to_a, menu_data[1].to_a
unpaid_list, paid_list = "", ""
unpaid_sum, paid_sum, line_num, checker = 0, 0, 0, 0
selected_register_data[-1], selected_register_data[-2] = 0, 0
selected_register_data.each_with_index do |value, i|
    value.to_i.times do
        price = menu_prices[i].to_i
        price_name = "#{price}円:#{menu_names[i]}<br>"

        if paid_line_nums.include?(checker.to_s) then #cgiで受け取った行数を元に精算済みかをチェックしてhtmを振り分け,合計金額を算出
            paid_list += price_name
            paid_sum += price
            register_data[desk_num][i] = register_data[desk_num][i].to_i - 1
        else
            unpaid_list += <<-EOS
                <input type=checkbox name="to_pay" value="#{line_num}">#{price_name}
                EOS
            unpaid_sum += price
            line_num += 1
        end
        checker += 1
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
<html><body>
    卓番号:#{cgi["desk_num"]}
    <br><br>
    #{paid_list}
    精算対象金額：#{paid_sum}円
    <br><br>
    <form name="calc" action="./register-main.rb" method="post">
        #{unpaid_list}<br>
        未精算金額：#{unpaid_sum}円<br>
        <input type="hidden" name="desk_num" value="#{desk_num+1}">
        <input type="submit" value="会計対象を選択して個別会計を行う">
    </form>
    <form name="calc" action="./register-standby.rb" method="post">
        <input type="hidden" name="desk_num" value="#{desk_num+1}">
        <input type="submit" value="会計を完了して席番号指定に戻る">
    </form>
    <a href="./register-standby.rb">誤った卓番号を選択したので会計を行わずに元に戻る</a>
</body></html>
EOF
