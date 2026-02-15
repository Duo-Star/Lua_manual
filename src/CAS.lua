--CAS初步
--作者：Duo  QQ：113530014
--条目将向你展示Nature的强大CAS作用
--我将通过网络导入Nature，所以可能会有延时


--Computer algebra system
--计算机代数系统，他可以让计算机像人类一样去计算，变量不需要先定义，像解方程一样处理。
--它可以保存数据结构，输入sqrt(2)得到的是根号二这个结构，而不是1.414.....

--本CAS采用table存储算式结构
--如{Add_,1,{Mul_,2,3}} 代表 1+2/3


nature_url="https://lua.yswy.top/index/api/manualdata?manual_id=2551"

function main()
  --计算
  printf( Add(Log(2,3),4) )--  ->log(2,48)
  printf( Mul(Sec(2,3),4) )--  -> 32
  printf( Div(Sec(2,3),4) )--  -> 2
  printf(cas(Add(Div(1,7),Div(1,3))))--  ->10/21
  --代数
  a=sym("a")--  -> a
  b=sym(Sqrt(2,0.5)) --  ->sqrt(2)
  printf( Sec(Sec(a,0.5),2) )--  -> a
  printf( Mul(2,Add(a,5)) )--  ->2a+10
  printf( b^2+1 )--  -> 3
  --导数
  printf(cas(Derivative(Sin(x))))--  ->cos(x)
  printf(cas(Derivative(Mul(x,2))))--  ->2
  printf(Derivative(Sec(x,3)))--  -> 3x^2
  printf(cas(Derivative(Sec(Add(x,1),2))))--  ->2x+2
end


Http.get(nature_url,function(data,code)
  if data==200 then
    --print(coda)
    code=cjson.decode(code)["data"]["manual_content"]
    assert(loadstring(code))()
    main()
   else
    print("error")
  end
end)






--以下来自百度百科 https://baike.baidu.com/item/%E8%AE%A1%E7%AE%97%E6%9C%BA%E4%BB%A3%E6%95%B0%E7%B3%BB%E7%BB%9F/10010926
--科学计算可分为两类:一类是纯数值的计算,例如求函数的值,方程的数值解;
--另一类计算是符号计算,又称代数运算,这是一种智能化的计算,处理的基本单位是字符串.
--字符串可以代表整数,有理数,实数和复数,也可以代表多项式,函数,还可以代表数学结构如集合,群的表示等等.
--人们在数学的教学和研究中用笔和纸进行的数学运算多为符号运算.
--从计算机发明的50多年时间里,用计算机进行的科学计算主要是数值计算,
--如天气预报,油藏模拟,航天等领域的大规模数值计算.
--长期以来,人们一直盼望有一个可以进行符号计算的计算机系统.
--早在50年代末,人们就开始了研究.
--进入80年代后,随着计算机的普及和人工智能的发展,用计算机进行代数运算的研究在国外发展非常迅速,
--涉及的数学领域也在不断地扩大,相继出现了多种功能齐全的计算机代数系统,
--这些系统可以分为专用系统和通用系统,
--专用系统主要是为解决物理,数学和其他科学分支的某些计算问题而设计的,
--专用系统在符号和数据结构上都适用于相应的领域,而且多数是用低级语言写成的,
--使用方便,计算速度快,在专业问题的研究中起着重要的作用.

