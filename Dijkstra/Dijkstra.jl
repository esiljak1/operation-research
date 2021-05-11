function provjeri_cvorove!(zauzeti, potencijali, putevi, velicina)
    for i in 1:size(zauzeti)[1]
      if zauzeti[i] == 0
        putevi[velicina, 1] = i
        putevi[velicina, 2] = potencijali[i, 2]
        putevi[velicina, 3] = potencijali[i, 1]
      end
    end
end

function najkraci_put(M, prvi)
  putevi = zeros(size(M)[1], 3)
  potencijali = zeros(size(M)[1], 2)
  potencijali[prvi, 1] = prvi
  potencijali[prvi, 2] = 0
  duzina = 0
  red = prvi
  zauzeti = zeros(size(M)[1])
  zauzeti[prvi] = 1

  putevi[1, 1] = prvi
  putevi[1, 2] = 0
  putevi[1, 3] = prvi

  k = 2

  while k < size(M)[1]

    for j in 1:size(M)[2]
      if M[red, j] != 0 && zauzeti[j] == 0
        if potencijali[j, 1] == 0
          potencijali[j, 1] = red
          potencijali[j, 2] = duzina + M[red, j]
        elseif duzina + M[red, j] < potencijali[j, 2]
          potencijali[j, 1] = red
          potencijali[j, 2] = duzina + M[red, j]
        end
      end
    end

    min = 0
    min_cvor = 0
    for i in 1:size(potencijali)[1]
      if min == 0 && zauzeti[i] == 0 && potencijali[i, 1] != 0
        min = potencijali[i, 2]
        min_cvor = i
      end

      if zauzeti[i] == 0 && potencijali[i, 1] != 0 && potencijali[i, 2] < min
        min = potencijali[i, 2]
        min_cvor = i
      end
    end

    if min_cvor == 0
      break
    end

    putevi[k, 1] = min_cvor
    putevi[k, 2] = min
    putevi[k, 3] = potencijali[min_cvor, 1]
    duzina = min
    red = min_cvor
    zauzeti[min_cvor] = 1
    k += 1
  end

  provjeri_cvorove!(zauzeti, potencijali, putevi, k)

  return putevi
end