# log P(Q|D) = sum (log((1-smoothing)*(f / |D|) + (smoothing)*(c / |C|)))
# f: number of times query word occurs in the document
# c: number of times query word occurs in the collection
# |D|: number of word occurrences in the document
# |C|: number of word occurrences in the collection
# smoothing: smoothing factor (0-1), the lambda is taken in Ruby
# Natural logarithim: Math.log
