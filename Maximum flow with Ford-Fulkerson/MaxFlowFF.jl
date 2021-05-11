using LinearAlgebra

function daj_izvor(C)
    for j in 1:size(C)[2]
        sveNule = true
        for i in 1:size(C)[1]
            if C[i, j] != 0
                sveNule = false
                break
            end
        end
        if sveNule
            return j
        end
    end
end

function ocitaj_put(put)
    i = size(put)[1]
    trazeni_put = zeros(1,3)

    for i in 1:3
        trazeni_put[1,i] = put[size(put)[1], i]
    end

    while put[i, 1] != 1
        for j in 1:(i-1)
            if put[j, 2] == put[i, 1]
                i = j
                trazeni_put = vcat(trazeni_put, [put[j, 1] put[j, 2] put[j, 3]])
                break
            end
        end
    end

    return trazeni_put
end

function izmijeni_matricu!(E, put)

    delta = minimum(put[:, 3])

    for i in 1:size(put)[1]
        red = trunc(Int, put[i, 1])
        kolona = trunc(Int, put[i, 2])

        E[red, kolona] -= delta
        E[kolona, red] += delta
    end
end

function bfs(E)
    uzeti_cvorovi = zeros(size(E)[1])

    red = zeros(0)
    push!(red, 1)
    uzeti_cvorovi[1] = 1

    put = zeros(1, 3)

    i = 1

    while i <= size(red)[1]
        trenutni_cvor = trunc(Int, red[i])

        for j in 1:size(E)[2]
            if E[trenutni_cvor, j] != 0 && uzeti_cvorovi[j] == 0
                push!(red, j)
                uzeti_cvorovi[j] = 1
                put = vcat(put, [trenutni_cvor j E[trenutni_cvor, j]])
                if j == size(E)[1]
                    return put
                end
            end
        end
        i += 1
    end

    return nothing

end

function ocitaj_rjesenje(matrica, E)
    ret = zeros(size(matrica)[1], size(matrica)[2])

    for i in 1:size(ret)[1]
        for j in 1:size(ret)[2]
            if E[i, j] != 0
                ret[i, j] = matrica[j, i]
            else
                ret[i, j] = 0
            end
        end
    end

    return ret, sum(matrica[:,1])
end

function protokEK(E)
    rezidualna = copy(E)

    put = bfs(rezidualna)

    while put != nothing
        najkraci_put = ocitaj_put(put)
        izmijeni_matricu!(rezidualna, najkraci_put)

        put = bfs(rezidualna)
    end

    return ocitaj_rjesenje(rezidualna, E)
end

E=[0 3 0 3 0 0 0 0;0 0 4 0 0 0 0 0;0 0 0 1 2 0 0 0;0 0 0 0 2 6 0 0;0 1 0 0 0 0 0 1;0 0 0 0 2 0 9 0;0 0 0 0 3 0 0 5;0 0 0 0 0 0 0 0];
X,V = protokEK(E)
