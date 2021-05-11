#Radili: Sadžak Nejra (18394),
#       Šiljak Emin (18484)

Pkg.add("GLPK")
Pkg.add("JuMP")

using GLPK
using JuMP
using LinearAlgebra

#tip = 0 - balansirani
#tip = 1 - veći kapacitet snabdjevača od kapaciteta potrošača
#tip = 2 - veći kapacitet potrošača od kapaciteta snabdjevača

function daj_tip_problema(S, P)
    if sum(S) == sum(P)
        return 0
    elseif sum(S) > sum(P)
        return 1
    else
        return 2
    end
end

function lin_prog(C, S, P, tip)
    m = Model(GLPK.Optimizer)
    @variable(m, x[1:size(C)[1], 1:size(C)[2]] >= 0, Int)
    @expression(m, expr, sum(C[i, j] * x[i, j] for i in 1:size(C)[1] for j in 1:size(C)[2]))
    @objective(m, Min, expr)

    if tip == 0
        for i in 1:size(C)[1]
            @constraint(m, sum(x[i, j] for j in 1:size(C)[2]) == S[i])
        end

        for i in 1:size(C)[2]
            @constraint(m, sum(x[j, i] for j in 1:size(C)[1]) == P[i])
        end
    elseif tip == 1
        for i in 1:size(C)[1]
            @constraint(m, sum(x[i, j] for j in 1:size(C)[2]) <= S[i])
        end

        for i in 1:size(C)[2]
            @constraint(m, sum(x[j, i] for j in 1:size(C)[1]) == P[i])
        end
    else
        for i in 1:size(C)[1]
            @constraint(m, sum(x[i, j] for j in 1:size(C)[2]) == S[i])
        end

        for i in 1:size(C)[2]
            @constraint(m, sum(x[j, i] for j in 1:size(C)[1]) <= P[i])
        end
    end
    optimize!(m)

    matrica = zeros(size(C)[1], size(C)[2])
    for i in 1:size(C)[1]
        for j in 1:size(C)[2]
            matrica[i, j] = value(x[i, j])
        end
    end

    return matrica, objective_value(m)
end

#C - matrica jediničnih cijena transporta
#S - vektor kapaciteta snabdjevača
#P - vektor kapaciteta potrošača
function provjeri_ulazne_podatke(C,S,P)
    if size(C)[1] != size(S)[1]
        return "Neispravni ulazni parametri"
    elseif size(C)[2] != size(P)[1]
        return "Neispravni ulazni parametri"
    end
    return ""
end

function transport(C,S,P)

    poruka = provjeri_ulazne_podatke(C, S, P)
    if poruka != ""
        return poruka
    end

    tip = daj_tip_problema(S, P)
    lin_prog(C, S, P, tip)
end

C=[3 2 10;5 8 12;4 10 5;7 15 10];
S=[20,50,60,10];
P=[20,40,30];
X,V=transport(C,S,P)

C1=[8 18 16 9 10;10 12 10 3 15;12 15 7 16 4];
S1=[90,50,80];
P1=[30,50,40,70,30];
X,V = transport(C1,S1,P1)

C2=[10 12 0;8 4 3;6 9 4;7 8 5];
S2=[20,30,20,10];
P2=[40,10,30];
X,V = transport(C2, S2, P2)

C3 = [20 40 25 70; 30 50 35 80; 25 45 30 75];
S3 = [200, 250, 150];
P3 = [300, 180, 140, 100];
X,V = transport(C3, S3, P3)

C4 = [50 10 90 40 100; 20 100 80 70 40; 60 80 120 60 30];
S4 = [75, 75, 50];
P4 = [60, 40, 30, 50, 40];
X,V = transport(C4, S4, P4)

C5 = [3 10 4 2 3; 7 5 8 4 10; 5 8 15 7 12; 10 12 10 8 4];
S5 = [200, 200, 150, 200];
P5 = [100, 200, 400, 200, 100];
X,V = transport(C5, S5, P5)

C6 = [8 9 4 6; 6 9 5 3; 5 6 7 4];
S6 = [100, 120, 140];
P6 = [90, 125, 80, 65];
X,V = transport(C6, S6, P6)

C7 = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65; 25 80 95 30];
S7 = [4, 8, 15, 10, 5];
P7 = [8, 7, 6, 8];
X,V = transport(C7, S7, P7)

#Neispravan test - nepotpun vektor S
C8 = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65; 25 80 95 30];
S8 = [4, 8, 15, 10];
P8 = [8, 7, 6, 8];
X = transport(C8, S8, P8)

#Neispravan test - nepotpun vektor P
C9 = [8 9 4 6; 6 9 5 3; 5 6 7 4];
S9 = [100, 120, 140];
P9 = [90, 125, 80];
X = transport(C9, S9, P9)


println(X)
println(V)
