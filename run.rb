load 'method.rb'
# all numbers should be float
# smoothing = 0.5
# f = 10.0
# c = 200.0
# big_d = 700.0
# big_c = 100000.0
# puts retrieve(f,c,big_d,big_c,smoothing)
# f += 1
# puts retrieve(f,c,big_d,big_c,smoothing)
# c += 1
# puts retrieve(f,c,big_d,big_c,smoothing)
filename = "data/latimes.dat.gz"
indexname = "inverted_index.txt"
doclistname = "doc_list.txt"
array = []
query = "query.txt"
t1 = Time.now
# index = load_index(indexname)
# doc_list = load_doclist(doclistname)
File.open(query, "r") { |file|
  file.each do |line|
    array = tokenize(line)
    array.each do |token|

    end
  end
}
t2 = Time.now
puts t2 - t1
