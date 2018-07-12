#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
require './def'
cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin
desk_num = cgi["desk_num"].to_i - 1
#paid_line_nums = cgi.params["to_pay"]
#if to_pay == nil then write orderlog

register_data_selected = CSV.read('register.csv', encoding: "utf-8")[desk_num].to_a
menu_name = CSV.read('MenuData.csv', encoding: "utf-8")[0].to_a + ["memo"]








=begin
#卓ファイルの更新と表示用HTMLの準備
menu_names = read_file_line("MenuName.txt")
menu_prices = read_file_line("MenuPrice.txt")
desk_eles = read_file_line(desk_num)

num_of_people = desk_eles[0] #人数
ordered_quantity_of_the_desk = desk_eles[1..-1] #注文個数

line_num, checker, sum_paid, sum_unpaid = 0, 0, 0, 0#新しい行番号、精算済みチェッカー、精算済み金額、未精算金額
htm_paid, htm_unpaid = "", ""#精算済みと未精算のhtm表示用

f=open(desk_num, "w:UTF-8")#精算済みのものを数を減らして書き込む
    f.write("#{num_of_people}\n")

    ordered_quantity_of_the_desk.each_with_index{ |quantity, i|
        unpaid_quantity = 0 #品ごとに精算されてない個数を数える(ブロックの最後で書き込み)

        quantity.to_i.times do
            htm = "#{menu_prices[i]}円:#{menu_names[i]}<br>"
            price = menu_prices[i].to_i

            if paid_line_nums.include?(checker.to_s) then #cgiで受け取った行数を元に精算済みかをチェックしてhtmを振り分け,合計金額を算出
                htm_paid << htm
                sum_paid += price
            else
                htm_unpaid << ("<input type=checkbox name=\"to_pay\" value=\"#{line_num}\">" + htm)
                sum_unpaid += price
                line_num += 1
                unpaid_quantity += 1
            end
            checker += 1
        end
        f.write("#{unpaid_quantity}\n")
    }
f.close
=end
rescue
    error_cgi
end
print <<EOF
<html><body>
    #{htm_paid}
    精算済金額：#{sum_paid}円<br><br>
    <form name="calc" action="./register-main.rb" method="post">
        #{htm_unpaid}<br>
        未精算金額：#{sum_unpaid}円<br>
        <input type="hidden" name="desk_num" value="#{desk_num}">
        <input type="submit" value="会計対象を選択して個別会計を行う">
    </form>
    <form name="calc" action="./register-standby.rb" method="post">
        <input type="hidden" name="desk_num" value="#{desk_num}">
        <input type="submit" value="会計を完了して席番号指定に戻る">
    </form>
</body></html>
EOF
