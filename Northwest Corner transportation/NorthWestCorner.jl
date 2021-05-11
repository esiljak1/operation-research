using LinearAlgebra

function daj_min(a, b)
    if a < b
        return a
    return b
end

function nadji_pocetno_SZU(C, I, O)

    I = transpose(I)
    if size(I)[1] != size(C)[1] || size(O) != size(C)[2]
        return "Pogrešno poslani parametri"
    end

    red = 1
    kolona = 1

    while red != size(C)[1] && kolona != size(C)[2]
        min = daj_min(I[red], O[kolona])

        I[red] -= min
        O[kolona] -= min
        C[red, kolona] = min

        if(I[red] == 0)
            red++
        else
            kolona++
        end
    end

end
