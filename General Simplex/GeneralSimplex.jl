using LinearAlgebra

status_optimum = 0
status_degeneric = 1
status_duplicate_optimum = 2
status_infinity = 3
status_invalid_fields = 4
status_error = 5

status = status_optimum

function postavi_prvu_kolonu_varijable(A, kolona)
    A[:, 2], A[:, kolona] = A[:, kolona], A[:, 2]
    return A
end

function provjeri_varijable(A, vsigns)
    j = 2
    for i in 2:size(vsigns)[1] + 1
        if vsigns[i - 1] == -1
            A[:, j] = A[:, j] .* -1
        elseif vsigns[i - 1] == 0
            postavi_prvu_kolonu_varijable(A, j)
            dodatna_kolona = A[:, 2] .* -1
            bazna_kolona = A[:, 1]
            A = A[:, 2:end]
            A = hcat(dodatna_kolona, A)
            A = hcat(bazna_kolona, A)
            j = j + 1
        end
        j = j + 1
    end

    return A
end

function dodaj_pomocne_varijable(A, csigns)
    kolona = zeros(size(A)[1], 1)

    for i in 1:size(csigns)[1]
        if csigns[i] == -1
            kolona[i, 1] = 1
            A = hcat(A, kolona)
            kolona[i, 1] = 0
        end
    end

    return A
end

function dodaj_prekoracenja(A, csigns)
    kolona = zeros(size(A)[1], 1)

    for i in 1:size(csigns)[1]
        if csigns[i] == 1
            kolona[i, 1] = -1
            A = hcat(A, kolona)
            kolona[i, 1] = 0
        end
    end

    return A
end

function dodaj_vjestacke_varijable(A, csigns)
    kolona = zeros(size(A)[1], 1)

    for i in 1:size(csigns)[1]
        if csigns[i] != -1
            kolona[i, 1] = 1
            A = hcat(A, kolona)
            kolona[i, 1] = 0
        end
    end

    return A
end

function dodaj_vrijednost_baza(A, b)
    A = hcat(b, A)

    return A
end

function daj_broj_vjestackih(csigns)
    broj_vjestackih = 0

    for i in 1:size(csigns)[1]
        if csigns[i] != -1
            broj_vjestackih = broj_vjestackih + 1
        end
    end

    return broj_vjestackih
end

function dodaj_M_red(goal, A, csigns)
    M_red = zeros(1, size(A)[2])

    broj_vjestackih = daj_broj_vjestackih(csigns)

    if broj_vjestackih == 0
        return A
    end
    for i in 1:size(A)[1]
        if csigns[i] != -1
            for j in 1:(size(A)[2] - broj_vjestackih)
                if A[i, j] != 0
                    M_red[1, j] = M_red[1, j] - A[i, j]
                end
            end
        end
    end

    M_red[1, 1] = M_red[1, 1] * -1

    if goal == "min"
        M_red = M_red.*-1
        M_red[1,1] = M_red[1,1]*-1
    end

    A = vcat(A, M_red)
end

function dodaj_posljednji_red(goal, c, A)
    red = zeros(1, size(A)[2] - size(c)[2] - 1)
    c = hcat(c, red)
    c = hcat(zeros(1, 1), c)

    if goal == "min"
        c = c.*-1
    end

    A = vcat(A, c)
    return A
end

function formiraj_pocetnu_tabelu(goal, c, A, b, csigns, vsigns)
    A = dodaj_pomocne_varijable(A, csigns)
    A = dodaj_prekoracenja(A, csigns)
    A = dodaj_vjestacke_varijable(A, csigns)
    A = dodaj_vrijednost_baza(A, b)
    A = dodaj_M_red(goal, A, csigns)
    A = dodaj_posljednji_red(goal, c, A)
    A = provjeri_varijable(A, vsigns)

    return A
end

function vektor_ispravan(vektor)
    for i in 1:size(vektor)[1]
        if (vektor[i, 1] != 1) && (vektor[i, 1] != -1) && (vektor[i, 1] != 0)
            return false
        end
    end
    return true
end

function provjeri_parametre(goal, c, A, b, csigns, vsigns)
    if goal != "max" && goal != "min"
        return ("Goal isključivo mora biti oblika max/min", status_error)
    end

    if (size(c)[2] != size(A)[2]) || (size(c)[2] != size(vsigns)[1])
        return ("Veličina vektora c se ne poklapa sa širinom matrice A ili veličinom vektora vsigns", status_error)
    end

    if (size(b)[1] != size(A)[1]) || (size(b)[1] != size(csigns)[1])
        return ("Veličina vektora b se ne poklapa sa širinom matrice A ili veličinom vektora csigns", status_error)
    end

    if (!vektor_ispravan(csigns)) || (!vektor_ispravan(vsigns))
        return ("Vektor vsigns i/ili vektor csigns sadrži vrijednosti koje nisu 1, -1 ili 0", status_error)
    end

    return ("", 0)
end

function je_li_vjestacka_baza(tabela, posmatrani_red, broj_vjestackih)

    for j in (size(tabela)[2] - broj_vjestackih + 1):size(tabela)[2]
        je_li_baza = true
        broj_jedinica = 0
        for i in 1:size(tabela)[1]
            if tabela[i, j] == 1
                broj_jedinica = broj_jedinica + 1
            elseif tabela[i, j] != 0
                je_li_baza = false
                break
            end

            if broj_jedinica > 1
                je_li_baza = false
                break
            end
        end

        if je_li_baza
            return true
        end
    end

    return false
end

function izbrisi_M_red(tabela, posmatrani_red)
    temp = tabela[size(tabela)[1], :]
    temp = transpose(temp)
    tabela = tabela[1:(posmatrani_red - 1), :]
    tabela = vcat(tabela, temp)

    return tabela
end

function daj_pivota(tabela, posmatrani_red, broj_vjestackih)

    sirina = size(tabela)[2]

    if posmatrani_red != size(tabela)[1]
        if !je_li_vjestacka_baza(tabela, posmatrani_red, broj_vjestackih)
            tabela = izbrisi_M_red(tabela, posmatrani_red)
        end
    end

    if posmatrani_red == size(tabela)[1]
        sirina = size(tabela)[2] - broj_vjestackih
    end

    max_kolona = 2

    for i in 3:sirina
        if tabela[posmatrani_red, i] > tabela[posmatrani_red, max_kolona]
            max_kolona = i
        elseif tabela[posmatrani_red, i] == tabela[posmatrani_red, max_kolona] && posmatrani_red != size(tabela)[1]
            if tabela[posmatrani_red + 1, i] > tabela[posmatrani_red + 1, max_kolona]
                max_kolona = i
            end
        end
    end

    if tabela[posmatrani_red, max_kolona] <= 0
        #terminiranje algoritma jer u posmatranom redu nema pozitivnih brojeva, nisam siguran je li <= ili < 0
        if posmatrani_red != size(tabela)[1]
            return tabela, -1, 0
        end
        return tabela, 0, 0
    end

    max_red = 1
    min_kolicnik = -1

    for i in 1:(posmatrani_red - 1)
        if min_kolicnik < 0
            if tabela[i, max_kolona] > 0
                kolicnik = tabela[i, 1] / tabela[i, max_kolona]
                max_red = i
                min_kolicnik = kolicnik
            end
        elseif tabela[i, max_kolona] > 0
            kolicnik = tabela[i, 1] / tabela[i, max_kolona]
            if kolicnik < min_kolicnik
                max_red = i
                min_kolicnik = kolicnik
            elseif kolicnik == min_kolicnik
                global status = status_degeneric
            end
        end
    end

    if tabela[max_red, max_kolona] <= 0
        if posmatrani_red != size(tabela)[1]
            return tabela, -1, 0
        end
        return tabela, -1, -1
    end

    return tabela, max_red, max_kolona
end

function je_li_baza(kolona)
    broj_jedinica = 0
    red = 0

    for i in 1:size(kolona)[1]
        if kolona[i] == 1
            broj_jedinica = broj_jedinica + 1
            red = i
        elseif kolona[i] != 0
            return 0
        end

        if broj_jedinica > 1
            return 0
        end
    end

    if broj_jedinica == 0
        return 0
    end

    return red
end

function daj_broj_pomocnih(csigns)
    broj = 0

    for i in 1:size(csigns)[1]
        if csigns[i] == -1
            broj = broj + 1
        end
    end

    return broj
end

function ocitaj_rjesenja(tabela, goal, broj_varijabli, csigns, vsigns)

    Z = tabela[size(tabela)[1], 1] * -1
    if goal == "min"
        Z = Z * -1
    end

    X = zeros(broj_varijabli)
    broj_ponovljenih_varijabli = 0

    for i in 2:(broj_varijabli + 1)
        red = je_li_baza(tabela[:, i])
        if red != 0
            X[i - 1] = tabela[red, 1]

            if vsigns[i - 1] == -1
                X[i - 1] = X[i - 1] * -1
            elseif vsigns[i - 1] == 0
                X[i - 1] = X[i - 1] - X[i]
            end
        else
            X[i - 1] = 0
        end

        if vsigns[i - 1] == 0
            broj_ponovljenih_varijabli = broj_ponovljenih_varijabli + 1
            i = i + 1
        end
    end

    Xd = zeros(size(tabela)[2] - broj_varijabli - 1 - daj_broj_vjestackih(csigns) - broj_ponovljenih_varijabli)

    j = 1
    for i in (broj_varijabli + 2 + broj_ponovljenih_varijabli):(size(tabela)[2] - daj_broj_vjestackih(csigns))
        red = je_li_baza(tabela[:, i])
        if red != 0
            Xd[j] = tabela[red, 1]
        else
            Xd[j] = 0
        end

        j = j + 1
    end

    Y = zeros(size(csigns)[1])
    broj_pomocnih = daj_broj_pomocnih(csigns)

    j = broj_varijabli + 2
    k = j + broj_pomocnih
    l = size(tabela)[2] - daj_broj_vjestackih(csigns) + 1


    for i in 1:size(csigns)[1]
        if csigns[i] == -1
            Y[i] = tabela[size(tabela)[1], j] * -1
            j = j + 1
        elseif csigns[i] == 1
            Y[i] = tabela[size(tabela)[1], k] * -1
            k = k + 1
        else
            Y[i] = tabela[size(tabela)[1], l]
            l = l + 1
        end
    end

    Yd = zeros(broj_varijabli)

    for i in 2:(broj_varijabli + 1)
        Yd[i - 1] = tabela[size(tabela)[1], i] * -1
    end

    broj_nula = 0

    for i in 2:(size(tabela)[2] - daj_broj_vjestackih(csigns))
        if (i - 1 <= size(vsigns)[1]) && (vsigns[i - 1] == 0)
            if tabela[size(tabela)[1], i - 1] - tabela[size(tabela)[1], i] == 0
                broj_nula = broj_nula + 1
            end
            i = i + 1
        elseif tabela[size(tabela)[1], i] == 0
            broj_nula = broj_nula + 1
        end
    end

    if broj_nula > size(tabela)[1] - 1
        if status != status_degeneric
            global status = status_duplicate_optimum
        end
    elseif status != status_degeneric
        status = status_optimum
    end

    return Z, X, Xd, Y, Yd, status

end

function provjeri_znak_b(A, b, csigns)
    for i in 1:size(b)[1]
        if b[i] < 0
            b[i] = b[i] * -1
            A[i, :] = A[i, :] .* -1
            csigns[i] = csigns[i] * -1
        end
    end

    return A,b,csigns
end

function general_simplex(goal, c, A, b, csigns = nothing, vsigns = nothing)
    if csigns == nothing
        csigns = ones(size(A)[1])
        vsigns = ones(size(A)[2])
        if goal == "max"
            csigns = csigns .* -1
        end
    elseif vsigns == nothing
        vsigns = ones(size(A)[2])
    end

    odgovor = provjeri_parametre(goal, c, A, b, csigns, vsigns)

    if odgovor[1] != ""
        return status_error
    end

    A,b,csigns = provjeri_znak_b(A,b,csigns)

    A = formiraj_pocetnu_tabelu(goal, c, A, b, csigns, vsigns)
    m_faktor = 0

    if daj_broj_vjestackih(csigns) != 0
        m_faktor = 1
    end

    broj_vjestackih = daj_broj_vjestackih(csigns)
    velicina_tabele = size(A)[1]

    while true

        pozicija_pivota = daj_pivota(A, size(A)[1] - m_faktor, broj_vjestackih)

        A = pozicija_pivota[1]

        if velicina_tabele != size(A)[1]
            m_faktor = 0
        end

        red = pozicija_pivota[2]
        kolona = pozicija_pivota[3]

        if (red, kolona) == (-1, -1)
            #U beskonacnosti rjesenje
            return Inf, status_infinity
        elseif (red, kolona) == (0, 0)
            #Pronadjeno rjesenje
            return ocitaj_rjesenja(A, goal, size(vsigns)[1], csigns, vsigns)
        elseif (red, kolona) == (-1, 0)
            return NaN, status_invalid_fields
        end

        A[red, :] = A[red, :] ./ A[red, kolona]
        for i in 1:size(A)[1]
            if i != red
                transformirani_red = A[red, :] .* -A[i, kolona]
                A[i, :] = A[i, :] + transformirani_red
            end
        end

    end


    return false

end

function ispisi_tabelu(A)
    println("----------------------------")
    for i in 1:size(A)[1]
        println(round.(A[i, :]; digits = 2))
    end
    println("----------------------------")
end
