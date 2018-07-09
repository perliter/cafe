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