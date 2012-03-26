require "zlib"
require "stemmify"

STOPWORDS = open("stopwords").read

def retrieve(f,c,big_d,big_c,smoothing)
  if f.class && c.class && big_d.class && smoothing.class == Float
    Math.log((1-smoothing)*(f/big_d)+(smoothing)*(c/big_c))
  else
    puts "Your inputs are not in float"
  end
end

def get_data(filename)
  Zlib::GzipReader.open(filename)
end

def read_data(filename)
  Zlib::GzipReader.open(filename).read
end

def tokenize(string)
  terms = []
  string.downcase.split(/[^a-z_\-<>\/0-9]/).each do |t|
    if STOPWORDS.match(t).nil?
      terms << t.stem
    end
  end
  terms
end

def create_list(filename)
  @doc_list = {}
  inside_doc = false
  in_length = false
  docid = 0
  record = []
  get_data(filename).each_with_index do |line,index|
    # if @doc_list.length > 10000
    #   break
    # end
    if line.match("<DOC>")
      inside_doc = true
    elsif line.match("<DOCNO>") && inside_doc
      record[0] = tokenize(line)[1]
    elsif line.match("<DOCID>") && inside_doc
      docid = tokenize(line)[1]
    elsif line.match("</LENGTH>")
      in_length = false
    elsif line.match("<LENGTH>")
      in_length = true
    elsif in_length == true && line.match("<P>").nil? && line.match("</P>").nil?
      # puts tokenize(line)[0]
      record[1] = tokenize(line)[0].to_i
    elsif line.match("</DOC>")
      if record[1].nil?
        record[1] = 1000
      end
      @doc_list[docid] = record
      record = []
      inside_doc = false
    end
    print "\r\e[0K#{@doc_list.length}"
  end
  File.open("doc_list.txt", "w") { |f|
    @doc_list.each do |i|
      f.write "#{i[0]},#{i[1][0]},#{i[1][1]}\n"
    end
  }
end

def load_index(indexname)
  index_h = {}
  inner_h = {}
  key = ""
  docid = 0
  File.open(indexname, "r") { |file|
    file.each_with_index do |line,i| 
      print "\r\e[0K#{i}"
      if i > 50
        break
      end
      if i % 2 == 0
        key = line.chop!
      elsif i % 2 == 1
        line.split("\t").each_with_index do |item,j|
          if j % 2 == 0 # docid
            docid = item.strip!.to_i
          elsif j % 2 == 1 # tf
            inner_h[docid] = item.strip!.to_i
          end
        end
        index_h[key] = inner_h
        inner_h = {}
      end
    end
  }
  puts "" # prepares for next line of output
  index_h
end

def load_doclist(doclistname)
  docid = 0
  docno = ""
  doclength = 0
  doc_list = {}
  File.open(doclistname, "r") { |file|
    file.each_with_index do |line, i|
      items = line.split(",")
      docid = items[0].to_i
      docno = items[1]
      doclength = items[2].to_i
      doc_list[docid] = [docno, doclength]
    end
  }
  doc_list
end
# log P(Q|D) = sum (log((1-smoothing)*(f / |D|) + (smoothing)*(c / |C|)))
# f: number of times query word occurs in the document
# c: number of times query word occurs in the collection
# |D|: number of word occurrences in the document
# |C|: number of word occurrences in the collection
# smoothing: smoothing factor (0-1), the lambda is taken in Ruby
# Natural logarithim: Math.log
