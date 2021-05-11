using LinearAlgebra

function rasporedi(m)

    

    for i in 1:size(m)[1]
        tmp = minimum(m[i, :])
        m[i, :] .-= tmp
    end

    for i in 1:size(m)[2]
        tmp = minimum(m[:, i])
        m[:, i] .-= tmp
    end

    broj = broj_nula(m)

    while broj > 0
        zavisni_nezavisni = zeros(size(m)[1], size(m)[2])
        postavi_zavisne_nezavisne!(zavisni_nezavisni, m)

        oznaceni_redovi = zeros(0)
        oznacene_kolone = zeros(0)
    end

    return m
end

function oznaci_redove_kolone!(oznaceni_redovi, oznacene_kolone, zavisni_nezavisni)
    for i in 1:size(zavisni_nezavisni)[1]
        for j in 1:size(zavisni_nezavisni)[2]
            if zavisni_nezavisni[i, j] == -1
                push!(oznaceni_redovi, i)
                push!(oznacene_kolone, j)
        end
    end

    while(true)
        temp_redovi = zeros(0)
        for i in 1:size(oznacene_kolone)[1]
            for j in 1:size(zavisni_nezavisni)[1]
                if zavisni_nezavisni[j, oznacene_kolone[i]] == 1
                    push!(temp_redovi, j)
                end
            end
        end

        for i in 1:size(temp_redovi)[1]
            for j in 1:size(zavisni_nezavisni)[2]
                if zavisni_nezavisni[temp_redovi[i], j] == -1

                end
            end
        end
    end
end

function postavi_zavisne_nezavisne!(zavisni_nezavisni, m)
    for i in 1:size(m)[1]
        for j in 1:size(m)[2]
            if m[i, j] == 0
                postavi_zavisnost!(zavisni_nezavisni, i, j)
            end
        end
    end
end

function postavi_zavisnost!(matrica, red, kolona)
    for i in 1:size(m)[2]
        if m[red, i] == 1
            m[red, kolona] = -1
            return
        end
    end

    for i in 1:size(m)[1]
        if m[i, kolona] == 1
            m[red, kolona] = -1
            return
        end
    end

    m[red, kolona] = 1
end

function broj_nula(m)
    broj = 0

    for i in 1:size(m)[1]
        for j in 1:size(m)[2]
            if m[i, j] == 0
                broj += 1
            end
        end
    end

    return broj
end

M = [80 20 23; 31 40 12; 61 1 1];
rasporedi(M)
