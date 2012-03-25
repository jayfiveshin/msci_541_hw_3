require "zlib"

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

# log P(Q|D) = sum (log((1-smoothing)*(f / |D|) + (smoothing)*(c / |C|)))
# f: number of times query word occurs in the document
# c: number of times query word occurs in the collection
# |D|: number of word occurrences in the document
# |C|: number of word occurrences in the collection
# smoothing: smoothing factor (0-1), the lambda is taken in Ruby
# Natural logarithim: Math.log
