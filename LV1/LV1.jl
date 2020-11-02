using Pkg
Pkg.add("Plots")
using Plots
using LinearAlgebra

#1. zadatak
3 * 456/23 + 31.54 + 2^6
sin(pi/7) * exp(0.3) * (2 + 0.9im)
sqrt(2) * log(10)
(5 + 3im) / (1.2 + 4.5im)

#2. zadatak
a = (atan(5) + exp(5.6)) / 3
b = (sin(pi/3))^(1/15)
c = (log(15) + 1) / 23
d = sin(pi/2) + cos(pi)

(a + b)*c
acos(b) * asin(c/11)
((a - b)^4)/d
c^(1/a) + (b*im) / (3 + 2im)

#3. zadatak
a = [1 -4im sqrt(2); log(complex(-1)) sin(pi/2) cos(pi/3); asin(0.5) acos(0.8) exp(0.8)]

transpose(a)
a + transpose(a)
a * transpose(a)
transpose(a) * a
det(a)
inv(a)

#4. zadatak

zeros(Int8, 8, 9)
ones(Int8, 7, 5)
rand(4, 9)
1 * Matrix(I, 5, 5)

#5. zadatak

a = [2 7 6; 9 5 1; 4 3 8]
zbirPrviRed = sum(a[1, :])
zbirDrugiRed = sum(a[2, :])
zbirTreciRed = sum(a[3, :])
zbirPrvaKolona = sum(a[:, 1])
zbirDrugaKolona = sum(a[:, 2])
zbirTrecaKolona = sum(a[:, 3])
zbirDijagonala = tr(a)
minPrviRed = minimum(a[1, :])
minDrugiRed = minimum(a[2, :])
minTreciRed = minimum(a[3, :])
minPrvaKolona = minimum(a[:, 1])
minDrugaKolona = minimum(a[:, 2])
minTrecaKolona = minimum(a[:, 3])
maxPrviRed = maximum(a[1, :])
maxDrugiRed = maximum(a[2, :])
maxTreciRed = maximum(a[3, :])
maxPrvaKolona = maximum(a[:, 1])
maxDrugaKolona = maximum(a[:, 2])
maxTrecaKolona = maximum(a[:, 3])
minDijagonala = minimum(diag(a))
maxDijagonala = maximum(diag(a))

#6. zadatak

a = [1 2 3; 4 5 6; 7 8 9]
b = [1 1 1; 2 2 2; 3 3 3]

c = sin.(a)
c = a^(1/3)
c = a .^(1/3)

#7. zadatak

reshape(0:1:99, 1, :)
reshape(0:0.01:0.99, 1, :)
reshape(39:-2:1, :, 1)

#8. zadatak

a = fill(7, 4, 4)
a = hcat(a, fill(0, 4, 4))
a = vcat(a, fill(3, 4, 8))

b = Matrix{Int}(I, 8, 8) + a
c = b[1:2:end,:]
d = b[:, 1:2:end]
e = b[1:2:end, 1:2:end]

#9. zadatak

f(x) = sin(x)
plot(f, -pi, pi, length = 101)

f(x) = cos(x)
plot(f, -pi, pi, length = 101)

f(x) = sin(1/x)
g(x) = cos(1/x)
plot(f, 1, 10, length = 101, linecolor = :red)
plot!(g, 1, 10, length = 101, seriestype = :scatter)

f(x) = sin(x)
g(x) = cos(x)
plot(f, -pi, pi, length = 101, seriestype = :steppost, linecolor = :blue)
plot!(g, -pi, pi, length = 101, seriestype = :sticks, linecolor = :orange)

#10. zadatak

x = [-8:0.5:8;]
y = [-8:0.5:8;]
f(x,y) = sin(sqrt(x^2 + y^2))
surface(x, y, f)
