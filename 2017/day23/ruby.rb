a = 1
# set b 99
b = 99
# set c b
c = b
# jnz a 2
if a != 0 goto label1
# jnz 1 5
if 1 != 0 goto label2
label1:
# mul b 100
b *= 100
# sub b -100000
b -= 100000
# set c b
c = b
# sub c -17000
c -= 17000
label2:
# set f 1
f = 1
# set d 2
d = 2
label5:
# set e 2
e = 2
label4:
# set g d
g = d
# mul g e
g *= e
# sub g b
g -= b
# jnz g 2
if g != 0 goto label3
# set f 0
f = 0
# sub e -1
e -= 1
label3:
# set g e
g = e
# sub g b
g -= b
# jnz g -8
if g != 0 goto label4
# sub d -1
d -= 1
# set g d
g = d
# sub g b
g -= b
# jnz g -13
if g != 0 goto label5
# jnz f 2
if f != 0 goto label6
# sub h -1
h -= -1
label6:
# set g b
g = b
# sub g c
g -= c
# jnz g 2
if g != 0 goto label7
# jnz 1 3
if 1 != 0 goto exit
label7:
# sub b -17
b -= 17
# jnz 1 -23
if 1 != 0 goto label2
exit:
