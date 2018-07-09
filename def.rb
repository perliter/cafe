#1行ずつファイルを読んで配列に
def read_file_line(filename)
    arr=[]
    f=open(filename, "r+:UTF-8")
        while line = f.gets
            arr << line.chomp
        end
    f.close
    return arr
end

#エラー処理
def error_cgi
	print "Content-Type:text/html;charset=EUC\n\n"
	print "*** CGI Error List ***<br />"
	print "#{CGI.escapeHTML($!.inspect)}<br />"
	$@.each {|x| print CGI.escapeHTML(x), "<br />"}
end
