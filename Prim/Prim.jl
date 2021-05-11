using LinearAlgebra

function daj_najkraci_put!(M, uzete_grane, da_li_je_uzeta_grana)
    min = 0
    pocetna = 0
    krajnja = 0

    for i in 1:size(uzete_grane)[1]
        for j in 1:size(M)[2]
            if min == 0
                if da_li_je_uzeta_grana[j] == 0 && M[uzete_grane[i], j] != 0
                    min = M[uzete_grane[i], j]
                    pocetna = uzete_grane[i]
                    krajnja = j
                end
            else
                if da_li_je_uzeta_grana[j] == 0 && M[uzete_grane[i], j] != 0 && M[uzete_grane[i], j] < min
                    min = M[uzete_grane[i], j]
                    pocetna = uzete_grane[i]
                    krajnja = j
                end
            end
        end
    end

    if krajnja != 0
        da_li_je_uzeta_grana[krajnja] = 1
        push!(uzete_grane, krajnja)
    end

    return pocetna, krajnja, min
end

function nadji_MST(M)
    grane = zeros(size(M)[1] - 1, 3)

    uzete_grane = [1]
    da_li_je_uzeta_grana = zeros(size(M)[1])
    da_li_je_uzeta_grana[1] = 1

    for i in 1:size(grane)[1]
        rezultat = daj_najkraci_put!(M, uzete_grane, da_li_je_uzeta_grana)
        if rezultat[1] == 0
            return sum(grane[:, 3]), grane
        end
        grane[i, 1] = rezultat[1]
        grane[i, 2] = rezultat[2]
        grane[i, 3] = rezultat[3]
    end

    return sum(grane[:, 3]), grane
end

M = [0 3 7 3 2; 3 0 6 8 5; 7 6 0 10 0; 3 8 10 0 4; 2 5 0 4 0;]
Z, grane = nadji_MST(M);
print(grane)
