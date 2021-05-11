function ispisi_rjesenje(par)
  println("Vrijednost varijabli problema:")

  for i in 1:size(par[1])[1]
    println("x", string(i), " = ", string(par[1][i]))
  end
  println("---------------------")
  println("Vrijednost cilja: Z = ", string(par[2]))
end

function daj_pivota(A)
  posljednji_red = size(A)[1]
  najveci_element = A[posljednji_red, 2]
  kolona_najveceg = 2

  for i in 3:size(A)[2]
    if A[posljednji_red, i] > najveci_element
      najveci_element = A[posljednji_red, i]
      kolona_najveceg = i
    end
  end

  if najveci_element > 0
    najmanji_kolicnik = A[1, 1] / A[1, kolona_najveceg]
    indeks_pivota = 1

    for i in 2:size(A)[1]
      temp = A[i, 1] / A[i, kolona_najveceg]

      if (temp < najmanji_kolicnik || najmanji_kolicnik <= 0) && temp > 0
        najmanji_kolicnik = temp
        indeks_pivota = i
      end
    end

    if najmanji_kolicnik <= 0
      return -1, -1
    end

    return indeks_pivota, kolona_najveceg
  end

  return 0, 0
end

function ocitaj_rjesenja(A)
  varijable = zeros(0)

  red = 1
  for j in 2:size(A)[2]
    broj_jedinica = 0
    for i in 1:size(A)[1]
      if A[i, j] == 1
        broj_jedinica = broj_jedinica + 1
        red = i
      elseif A[i, j] != 0
        broj_jedinica = -1
        break;
      end

      if broj_jedinica > 1
        broj_jedinica = -1
        break;
      end
    end

    if broj_jedinica == 1
      push!(varijable, A[red, 1])
    else
      push!(varijable, 0)
    end
  end

  return (varijable, -A[size(A)[1], 1])

end

function rijesi_simplex(A, b, c)
  if size(A)[1] != length(b) || size(A)[2] != length(c)
    return "Nije dobro unesena postavka zadatka"
  end

  broj_ogranicenja = length(b)
  b = reshape(b, length(b), 1)
  b = vcat(b, fill(0, 1, 1))

  A = vcat(A, reshape(c, 1, length(c)))
  A = hcat(b, A)

  jedinicna = 1*Matrix(I, broj_ogranicenja, broj_ogranicenja)
  jedinicna = vcat(jedinicna, fill(0, 1, broj_ogranicenja))

  A = hcat(A, jedinicna)
  
  pozicija = daj_pivota(A)

  while pozicija[1] != 0

    if pozicija[1] == -1
      return "Problem nema optimalno rješenje, tj. rješenje problema je u beskonačnosti"
    end

    red = pozicija[1]
    kolona = pozicija[2]

    A[red, :] = A[red, :] / A[red, kolona]
    for i in 1:size(A)[1]
      if i != red
        A[i, :] = A[i, :] + A[red, :]*(-A[i, kolona])
      end
    end

    pozicija = daj_pivota(A)

  end

  rjesenje = ocitaj_rjesenja(A)

  return rjesenje

end