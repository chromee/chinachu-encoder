def aaa(op={code: "aiueo"})
  bbb(op)
end

def bbb(op={code: "aiueo"})
  puts op[:code]
end

aaa({code: "bbbbb"})
