--Duolang
--"建造" 一个梦想中的 "编程语言"

code=
[[

//Duolang
//by Duo

a=F
b=T

c=func()
  if b :
    <<("hello world")
  else
    <<("#")
  ;
;

>>("1+1="..1+1)

>>(c())

]]


function run(str)
  assert(loadstring(editing(str)))()
end

function editing(str)
  local j
  local H=string.gsub
  j=H(str,"func","function")
  j=H(j,";","end")
  j=H(j,"F","false")
  j=H(j,"T","true")
  j=H(j,":","then")
  j=H(j,"//","--")
  j=H(j,">>","print")
  j=H(j,"<<","return")
  return j
end

run(code)
