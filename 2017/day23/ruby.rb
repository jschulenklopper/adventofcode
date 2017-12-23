a = 1
b = 99
c = b
if a != 0 goto label1
goto label2
label1:
b *= 100
b -= 100000
c = b
c -= 17000
label2:
f = 1
d = 2
label5:
e = 2
label4:
g = d
g *= e
g -= b
if g != 0 goto label3
f = 0
e -= 1
label3:
g = e
g -= b
if g != 0 goto label4
d -= 1
g = d
g -= b
if g != 0 goto label5
if f != 0 goto label6
h -= -1
label6:
g = b
g -= c
if g != 0 goto label7
goto exit
label7:
b -= 17
goto label2
exit:
