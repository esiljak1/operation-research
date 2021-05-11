using LinearAlgebra

#E - matrica m redova i 3 kolone
#jedan red odgovara grani u grafu
#prvi i drugi element u redu - početni i krajnji čvor
#treći element - težina grane

function daj_korijenski_cvor(ref_tezine, cvor)
    tren_cvor = cvor

    while true
        if ref_tezine[tren_cvor, 1] == 0
            return tren_cvor
        end

        tren_cvor = trunc(Int, ref_tezine[tren_cvor, 1])
    end
end

function daj_broj_cvorova(E)
    max1 = maximum(E[:, 1])
    max2 = maximum(E[:, 2])

    return max(max1, max2)
end

function grana_u_putu(poc, kr, T)
    for i in 1:size(T)[1]
        if T[i, 1] == kr && T[i, 2] == poc
            return true
        end
    end

    return false
end

function Kruskal(E)
    sortirano = E[sortperm(E[:, 3]), :]
    br_cvorova = daj_broj_cvorova(E)

    ref_tezine = zeros(br_cvorova, 2)

    T = zeros(1, 2)
    V = 0
    i = 1

    while size(T)[1] != br_cvorova
        pocetni_cvor = trunc(Int, sortirano[i, 1])
        krajnji_cvor = trunc(Int, sortirano[i, 2])
        tezina = sortirano[i, 3]

        if grana_u_putu(pocetni_cvor, krajnji_cvor, T)
            i += 1
            continue
        end


        korijenski_cvor_poc = daj_korijenski_cvor(ref_tezine, pocetni_cvor)
        korijenski_cvor_kraj = daj_korijenski_cvor(ref_tezine, krajnji_cvor)

        if (korijenski_cvor_kraj != korijenski_cvor_poc) || (korijenski_cvor_kraj == 0) || (korijenski_cvor_poc == 0)
            T = vcat(T, [pocetni_cvor krajnji_cvor])

            if korijenski_cvor_kraj != 0 && korijenski_cvor_poc != 0
                ref_tezine[korijenski_cvor_kraj, 1] = korijenski_cvor_poc
            else
                ref_tezine[krajnji_cvor, 1] = pocetni_cvor
            end

            V += tezina

            if tezina > ref_tezine[pocetni_cvor, 2]
                ref_tezine[pocetni_cvor, 2] = tezina
            end
        end

        i+=1
    end

    T = T[2:size(T)[1], :]

    return T, V
end

E4 = [1 2 23; 1 3 33; 1 4 25; 1 5 18; 1 6 22; 2 1 23; 2 3 27; 2 4 32; 2 5 15; 2 6 17; 3 1 33; 3 2 27; 3 4 14; 3 5 26; 3 6 35; 4 1 25; 4 2 32; 4 3 14; 4 5 29; 4 6 31; 5 1 18; 5 2 15; 5 3 26; 5 4 29; 5 6 13; 6 1 22; 6 2 17;6 3 35; 6 4 31; 6 5 13];
T,V=Kruskal(E4)

println(T)
println(V)
