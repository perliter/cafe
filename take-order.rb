#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'csv'
cgi = CGI.new

def input_html(num: 0, msg:, id:, name:, default_value: 0)
    form_width_1, form_width_2, form_height, font_size="12%", "19%", "10%", "100%"
    return <<-EOS
        #{num}: #{msg}<br>
        <input type="text" id="#{id}" name="#{name}" value="#{default_value}" style="width:#{form_width_1}; height:#{form_height}; font-size:#{font_size}">
        <input type="button" id="#{id}" style="width:#{form_width_2}; height:#{form_height}; font-size:#{font_size}" value="+" onclick="indecrementNum(this.id, 1)">
        <input type="button" id="#{id}" style="width:#{form_width_2}; height:#{form_height}; font-size:#{font_size}" value="-" onclick="indecrementNum(this.id, -1)">
        <br><br>
    EOS
end

#メニュー読み込み
orderform = ""
orderform += input_html(id:"desk",  name:"desk_num",       default_value: 8, msg: "座席番号")
orderform += input_html(id:"item0", name:"num_of_masters", default_value: 2, msg: "人数(追加注文時は0人で)")
menudata = CSV.read('MenuData.csv', encoding: "utf-8")
menudata[0].each_with_index do |item, i|
    orderform += input_html(num: i+1, msg: item, id:"item#{i+1}", name:"num")
end

print cgi.header("text/html; charset=utf-8")
print <<EOF
<html><body>
    <script>
        function indecrementNum(id,in_de){
            var num=document.getElementById(id);
            num.value=(num.value=="" ? 0 : parseInt(num.value))+in_de
        }
        function check(){
            if(window.confirm('注文内容を送信してよろしいですか？')){
                return true;
            }else{
                return false;
            }
        }
    </script>

    <form action="./take-order-complete.rb" method="post" onSubmit="return check()">
        <p style="font-size:50px;">
            #{orderform}
            <input type="submit" value="注文を確定して送信" style="width:80%; height:10%; font-size:100%">
        <\p>
        <p style="font-size:60px;">
            備考：<input type="text" name="memo" placeholder="何かあればここに入力して送信" style="width: 80%; height:60px; font-size:60px">
        <\p>
	</form>
</body></html>
EOF
