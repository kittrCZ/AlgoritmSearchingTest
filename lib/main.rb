require "benchmark"
require "binary_search_tree"
require "sorted_array"
require "unsorted_array"
require "win32ole"

class SearchingBenchmark
  def initialize
    ##############################################################
    #Změnit před začátekm benchmarku
    @cesta = 'C:\Users\Kittr\Desktop\ALG x03\ALGX03Hertus\lib'
    ##############################################################
    @dvojce = [[10,10000], [50, 1000], [100, 500], [500, 50], [1000, 10], [5000, 10]]
    @mereni = 10
    @unsorted = []
    @sorted = []
    @tree = []
 end

  def benchmark
    puts Time.now
    puts "-----------------------------------------------------------"
    puts "Probíhá měření - odhad doby trvání: 30minut"
    puts "Výsledky budou v adresáři LIB v souboru sorting.xls"
    for doba in 1..@mereni do
      puts "***********************************************************"
      puts "***********************************************************"
      puts "Probíhá měření číslo: #{doba}"
      @dvojce.each do |velikost,opakovani|
        puts "Probíhá nastavování hodnot polí, velikost:#{velikost} a pocet opakovani je: #{opakovani}"
        #Časové proměné pro unosrted pole
        cas_unsorted_insert = 0
        cas_unsorted_find = 0
        cas_unsorted_delete = 0

        #Časové proměné pro sorted pole
        cas_sorted_insert = 0
        cas_sorted_binary_find = 0
        cas_sorted_interpolar_find = 0
        cas_sorted_delete = 0

        #Časové proměné pro binární vyhledávací strom
        cas_tree_insert = 0
        cas_tree_find = 0
        cas_tree_delete = 0

        #prázdná pole připravená pro zbytky polí po operacích insert a delete
        zb_unsorted_ins = []
        zb_unsorted_del = []
        zb_sorted_ins = []
        zb_sorted_del = []
        zb_tree_ins = []
        zb_tree_del = []

        opakovani.times do#Vytvoření nových prázdných polí
        unsorted_array = UnsortedArray.new
        sorted_array = SortedArray.new
        tree = BinarySearchTree.new

        #Vložení hodnot do datových struktur
        #Výpočet časů a přidání jich do předpřipravených proměných
          for i in 0..velikost
            for i in 1..3 do
              value = rand(velikost)
              if (i == 1)
               cas_unsorted_insert += Benchmark.realtime { unsorted_array.insert(value) }
              elsif (i == 2)
               cas_sorted_insert += Benchmark.realtime { sorted_array.insert(value) }
              else
               cas_tree_insert += Benchmark.realtime { tree.insert(value) }
              end
            end
          end
          # Vložení velikosti polí po provedení operace insert do polích pro ně určených.
          zb_unsorted_ins << unsorted_array.length
          zb_sorted_ins << sorted_array.length
          zb_tree_ins << tree.length

          for i in 0..velikost
             for i in 1..4 do
              value = rand(velikost)
             if (i == 1)
                  cas_unsorted_find += Benchmark.realtime { unsorted_array.find(value) }
             elsif (i == 2)
                 cas_sorted_binary_find += Benchmark.realtime { sorted_array.binary_search(value) }
             elsif(i == 3)
                  cas_sorted_interpolar_find += Benchmark.realtime { sorted_array.interpolation_search(value) }
             else
                  cas_tree_find += Benchmark.realtime { tree.find(value) }
              end
            end
          end

          for i in 0..velikost
            for i in 1..3 do
              value = rand(velikost)
              if (i == 1)
                  cas_unsorted_delete += Benchmark.realtime { unsorted_array.delete(value) }
              elsif (i == 2)
                  cas_sorted_delete += Benchmark.realtime { sorted_array.delete(value) }
              else
                  cas_tree_delete += Benchmark.realtime { tree.delete(value) }
              end
            end
          end
         #Vložení velikostí jednotlivých polí po mětodě delete
         zb_unsorted_del << unsorted_array.length
         zb_sorted_del << sorted_array.length
         zb_tree_del << tree.length
         end

        zb_unsorted_ins_prumer = prumer(zb_unsorted_ins)
        zb_unsorted_del_prum = prumer(zb_unsorted_del)
        zb_unsorted_ins_med = median(zb_unsorted_ins)
        zb_unsorted_del_med = median(zb_unsorted_del)

        zb_sorted_ins_prum = prumer(zb_sorted_ins)
        zb_sorted_del_prum = prumer(zb_sorted_del)
        zb_sorted_ins_med = median(zb_sorted_ins)
        zb_sorted_del_med = median(zb_sorted_del)

        zb_tree_ins_prum = prumer(zb_tree_ins)
        zb_tree_del_prum = prumer(zb_tree_del)
        zb_tree_ins_med = median(zb_tree_ins)
        zb_tree_del_med = median(zb_tree_del)

         unsorted = []
         unsorted << doba
         unsorted << velikost
         unsorted << opakovani
         unsorted << cas_unsorted_insert
         unsorted << cas_unsorted_find
         unsorted << cas_unsorted_delete
         unsorted << zb_unsorted_ins_prumer
         unsorted << zb_unsorted_ins_med
         unsorted << zb_unsorted_del_prum
         unsorted << zb_unsorted_del_med
         @unsorted << unsorted

         sorted = []
         sorted << doba
         sorted << velikost
         sorted << opakovani
         sorted << cas_sorted_insert
         sorted << cas_sorted_binary_find
         sorted << cas_sorted_interpolar_find
         sorted << cas_sorted_delete
         sorted << zb_sorted_ins_prum
         sorted << zb_sorted_ins_med
         sorted << zb_sorted_del_prum
         sorted << zb_sorted_del_med
         @sorted << sorted

         tree = []
         tree << doba
         tree << velikost
         tree << opakovani
         tree << cas_tree_insert
         tree << cas_tree_find
         tree << cas_tree_delete
         tree << zb_tree_ins_prum
         tree << zb_tree_ins_med
         tree << zb_tree_del_prum
         tree << zb_tree_del_med
         @tree << tree
      end
    end
  end

def vysledky_unsorted
excel = WIN32OLE:: new('excel.Application')
workbook = excel.workbooks.add
worksheet = workbook.Worksheets(1)
worksheet.Select
# Připravení hlavičky výsledného xls
worksheet.Range('a2').value = ["Insert prumer"]
worksheet.Range('a3').value = ["Find prumer"]
worksheet.Range('a4').value = ["Delete prumer"]
worksheet.Range('a5').value = ["Insert median"]
worksheet.Range('a6').value = ["Find median"]
worksheet.Range('a7').value = ["Delete median"]
worksheet.Range('a8').value = ["Zbytky po insertu prumer"]
worksheet.Range('a9').value = ["Zbytky po insertu median"]
worksheet.Range('a10').value = ["Zbytky po deletu prumer"]
worksheet.Range('a11').value = ["Zbytek po deletu median"]

worksheet.Range('b1').value = ['(10:10000)']
worksheet.Range('c1').value = ['(50:1000)']
worksheet.Range('d1').value = ["(100:500)"]
worksheet.Range('e1').value = ["(500:50)"]
worksheet.Range('f1').value = ["(1000:10)"]
worksheet.Range('g1').value = ["(5000:10)"]
#Zapsání prumer jednotlivych dvojic do tabulky
prum_insert = []
prum_find = []
prum_delete = []
pole1=[]
pole2=[]
pole3=[]
@dvojce.each do |n,m|
 for i in 0..(@unsorted.length-1) do
   if (@unsorted[i][1]== n)
     pole1 << @unsorted[i][3]
     pole2 << @unsorted[i][4]
     pole3 << @unsorted[i][5]
   end
 end
end
for b in 0..5 do
  prum_insert << prumer(pole1[0,@mereni.to_i])
  for a1 in 0..(@mereni.to_i-1)
    pole1.delete_at(a1)
  end
end
for c in 0..5 do
  prum_find << prumer(pole2[0,@mereni.to_i])
  for a2 in 0..(@mereni.to_i-1)
    pole2.delete_at(a2)
  end
end
for d in 0..5 do
  prum_delete << prumer(pole3[0,@mereni.to_i])
  for a3 in 0..(@mereni.to_i-1)
    pole3.delete_at(a3)
  end
end

#Zapsání medianu jednotlivych dvojic do tabulky
med_insert = []
med_find = []
med_delete = []
pole4=[]
pole5=[]
pole6=[]
@dvojce.each do |n,m|
 for i in 0..(@unsorted.length-1) do
   if (@unsorted[i][1]== n)
     pole4 << @unsorted[i][3]
     pole5 << @unsorted[i][4]
     pole6 << @unsorted[i][5]
   end
 end
end
for e in 0..5 do
  med_insert << median(pole4[0,@mereni.to_i])
  for a4 in 0..(@mereni.to_i-1)
    pole4.delete_at(a4)
  end
end
for f in 0..5 do
  med_find << median(pole5[0,@mereni.to_i])
  for a5 in 0..(@mereni.to_i-1)
    pole5.delete_at(a5)
  end
end
for g in 0..5 do
  med_delete << median(pole6[0,@mereni.to_i])
  for a6 in 0..(@mereni.to_i-1)
    pole6.delete_at(a6)
  end
end

#Zapsani zbytku(součet všech medianu a prumeru v jednotlivych opakovaních)
med_zb_insert = []
med_zb_delete = []
prum_zb_insert = []
prum_zb_delete = []
pole7=[]
pole8=[]
pole9=[]
pole10=[]
@dvojce.each do |n,m|
 for i in 0..(@unsorted.length-1) do
   if (@unsorted[i][1]== n)
     pole7 << @unsorted[i][6]#ins prumer
     pole8 << @unsorted[i][7]#ins media
     pole9 << @unsorted[i][8]#del prumer
     pole10 << @unsorted[i][9]#del median
   end
 end
end
for h in 0..5 do
  prum_zb_insert << prumer(pole7[0,@mereni.to_i])
  for aa in 0..(@mereni.to_i-1)
    pole7.delete_at(aa)
  end
  
end

for i in 0..5 do
  med_zb_insert << median(pole8[0,@mereni.to_i])
  for ab in 0..(@mereni.to_i-1)
    pole8.delete_at(ab)
  end
end
for j in 0..5 do
  prum_zb_delete << prumer(pole9[0,@mereni.to_i])
  for ac in 0..(@mereni.to_i-1)
    pole9.delete_at(ac)
  end
end
for k in 0..5 do
  med_zb_delete << median(pole10[0,@mereni.to_i])
  for ad in 0..(@mereni.to_i-1)
    pole10.delete_at(ad)
  end
end

#Vytvoreni tabulky
worksheet.Range('b2').value = [prum_insert[0]]
worksheet.Range('c2').value = [prum_insert[1]]
worksheet.Range('d2').value = [prum_insert[2]]
worksheet.Range('e2').value = [prum_insert[3]]
worksheet.Range('f2').value = [prum_insert[4]]
worksheet.Range('g2').value = [prum_insert[5]]

worksheet.Range('b3').value = [prum_find[0]]
worksheet.Range('c3').value = [prum_find[1]]
worksheet.Range('d3').value = [prum_find[2]]
worksheet.Range('e3').value = [prum_find[3]]
worksheet.Range('f3').value = [prum_find[4]]
worksheet.Range('g3').value = [prum_find[5]]

worksheet.Range('b4').value = [prum_delete[0]]
worksheet.Range('c4').value = [prum_delete[1]]
worksheet.Range('d4').value = [prum_delete[2]]
worksheet.Range('e4').value = [prum_delete[3]]
worksheet.Range('f4').value = [prum_delete[4]]
worksheet.Range('g4').value = [prum_delete[5]]

  #Mediany
worksheet.Range('b5').value = [med_insert[0]]
worksheet.Range('c5').value = [med_insert[1]]
worksheet.Range('d5').value = [med_insert[2]]
worksheet.Range('e5').value = [med_insert[3]]
worksheet.Range('f5').value = [med_insert[4]]
worksheet.Range('g5').value = [med_insert[5]]

worksheet.Range('b6').value = [med_find[0]]
worksheet.Range('c6').value = [med_find[1]]
worksheet.Range('d6').value = [med_find[2]]
worksheet.Range('e6').value = [med_find[3]]
worksheet.Range('f6').value = [med_find[4]]
worksheet.Range('g6').value = [med_find[5]]

worksheet.Range('b7').value = [med_delete[0]]
worksheet.Range('c7').value = [med_delete[1]]
worksheet.Range('d7').value = [med_delete[2]]
worksheet.Range('e7').value = [med_delete[3]]
worksheet.Range('f7').value = [med_delete[4]]
worksheet.Range('g7').value = [med_delete[5]]
#Zbytky po polích
worksheet.Range('b8').value = [prum_zb_insert[0]]
worksheet.Range('c8').value = [prum_zb_insert[1]]
worksheet.Range('d8').value = [prum_zb_insert[2]]
worksheet.Range('e8').value = [prum_zb_insert[3]]
worksheet.Range('f8').value = [prum_zb_insert[4]]
worksheet.Range('g8').value = [prum_zb_insert[5]]

worksheet.Range('b9').value = [med_zb_insert[0]]
worksheet.Range('c9').value = [med_zb_insert[1]]
worksheet.Range('d9').value = [med_zb_insert[2]]
worksheet.Range('e9').value = [med_zb_insert[3]]
worksheet.Range('f9').value = [med_zb_insert[4]]
worksheet.Range('g9').value = [med_zb_insert[5]]

worksheet.Range('b10').value = [prum_zb_delete[0]]
worksheet.Range('c10').value = [prum_zb_delete[1]]
worksheet.Range('d10').value = [prum_zb_delete[2]]
worksheet.Range('e10').value = [prum_zb_delete[3]]
worksheet.Range('f10').value = [prum_zb_delete[4]]
worksheet.Range('g10').value = [prum_zb_delete[5]]

worksheet.Range('b11').value = [med_zb_delete[0]]
worksheet.Range('c11').value = [med_zb_delete[1]]
worksheet.Range('d11').value = [med_zb_delete[2]]
worksheet.Range('e11').value = [med_zb_delete[3]]
worksheet.Range('f11').value = [med_zb_delete[4]]
worksheet.Range('g11').value = [med_zb_delete[5]]

workbook.SaveAs(@cesta+'\sorting.xls')
workbook.Close
excel.Quit
puts "proběhlo zapsání do souboru"
end

def vysledky_sorted
excel = WIN32OLE:: new('excel.Application')
workbook = excel.Workbooks.Open(@cesta+'\sorting.xls')
worksheet = workbook.Worksheets(2)
worksheet.Select
# Připravení hlavičky výsledného xls
worksheet.Range('a2').value = ["Insert prumer"]
worksheet.Range('a3').value = ["Binay find prumer"]
worksheet.Range('a4').value = ["Interpolation find prumer"]
worksheet.Range('a5').value = ["Delete prumer"]
worksheet.Range('a6').value = ["Insert median"]
worksheet.Range('a7').value = ["Find bin. median"]
worksheet.Range('a8').value = ["Find inter. median"]
worksheet.Range('a9').value = ["Delete median"]
worksheet.Range('a10').value = ["Zbytky po insertu prumer"]
worksheet.Range('a11').value = ["Zbytky po insertu median"]
worksheet.Range('a12').value = ["Zbytky po deletu prumer"]
worksheet.Range('a13').value = ["Zbytek po deletu median"]

worksheet.Range('b1').value = ['(10:10000)']
worksheet.Range('c1').value = ['(50:1000)']
worksheet.Range('d1').value = ["(100:500)"]
worksheet.Range('e1').value = ["(500:50)"]
worksheet.Range('f1').value = ["(1000:10)"]
worksheet.Range('g1').value = ["(5000:10)"]
#Zapsání prumer jednotlivych dvojic do tabulky
prum_insert = []
prum_bin_find = []
prum_int_find = []
prum_delete = []
pole1=[]
pole2=[]
pole3=[]
pole4=[]
@dvojce.each do |n,m|
 for i in 0..(@sorted.length-1) do
   if (@sorted[i][1]== n)
     pole1 << @sorted[i][3]#insert
     pole2 << @sorted[i][4]#bin f
     pole3 << @sorted[i][5]#int f
     pole4 << @sorted[i][6]#delete
   end
 end
end
for a in 0..5 do
  prum_insert << prumer(pole1[0,@mereni.to_i])
  for aa in 0..(@mereni.to_i-1)
    pole1.delete_at(aa)
  end
end
for b in 0..5 do
  prum_bin_find << prumer(pole2[0,@mereni.to_i])
  for ab in 0..(@mereni.to_i-1)
    pole2.delete_at(aa)
  end
end
for c in 0..5 do
  prum_int_find << prumer(pole3[0,@mereni.to_i])
  for ac in 0..(@mereni.to_i-1)
    pole3.delete_at(ac)
  end
end
for d in 0..5 do
  prum_delete << prumer(pole4[0,@mereni.to_i])
  for ad in 0..(@mereni.to_i-1)
    pole4.delete_at(ad)
  end
end

#Zapsání medianu jednotlivych dvojic do tabulky
med_insert = []
med_bin_find = []
med_int_find = []
med_delete = []
pole5=[]
pole6=[]
pole7=[]
pole8=[]
@dvojce.each do |n,m|
 for i in 0..(@sorted.length-1) do
   if (@sorted[i][1]== n)
     pole5 << @sorted[i][3]
     pole6 << @sorted[i][4]
     pole7 << @sorted[i][5]
     pole8 << @sorted[i][6]
   end
 end
end
for e in 0..5 do
  med_insert << median(pole5[0,@mereni.to_i])
  for a1 in 0..(@mereni.to_i-1)
    pole5.delete_at(a1)
  end
end
for f in 0..5 do
  med_bin_find << median(pole6[0,@mereni.to_i])
  for a2 in 0..(@mereni.to_i-1)
    pole6.delete_at(a2)
  end
end
for g in 0..5 do
  med_int_find << median(pole7[0,@mereni.to_i])
  for a3 in 0..(@mereni.to_i-1)
    pole7.delete_at(a3)
  end
end
for h in 0..5 do
  med_delete << median(pole8[0,@mereni.to_i])
  for a4 in 0..(@mereni.to_i-1)
    pole8.delete_at(a4)
  end
end


#Zapsani zbytku(součet všech medianu a prumeru v jednotlivych opakovaních)
med_zb_insert = []
med_zb_delete = []
prum_zb_insert = []
prum_zb_delete = []
pole9=[]
pole10=[]
pole11=[]
pole12=[]
@dvojce.each do |n,m|
 for i in 0..(@sorted.length-1) do
   if (@sorted[i][1]== n)
     pole9 << @sorted[i][7]#ins prumer
     pole10 << @sorted[i][8]#ins media
     pole11 << @sorted[i][9]#del prumer
     pole12 << @sorted[i][10]#del median
   end
 end
end
for i in 0..5 do
  prum_zb_insert << prumer(pole9[0,@mereni.to_i])
  for a5 in 0..(@mereni.to_i-1)
    pole9.delete_at(a5)
  end
end
for j in 0..5 do
  med_zb_insert << median(pole10[0,@mereni.to_i])
  for a6 in 0..(@mereni.to_i-1)
    pole10.delete_at(a6)
  end
end
for k in 0..5 do
  prum_zb_delete << prumer(pole11[0,@mereni.to_i])
  for a7 in 0..(@mereni.to_i-1)
    pole11.delete_at(a7)
  end
end
for l in 0..5 do
  med_zb_delete << median(pole12[0,@mereni.to_i])
  for a8 in 0..(@mereni.to_i-1)
    pole12.delete_at(a8)
  end
end


#Vytvoreni tabulky
worksheet.Range('b2').value = [prum_insert[0]]
worksheet.Range('c2').value = [prum_insert[1]]
worksheet.Range('d2').value = [prum_insert[2]]
worksheet.Range('e2').value = [prum_insert[3]]
worksheet.Range('f2').value = [prum_insert[4]]
worksheet.Range('g2').value = [prum_insert[5]]

worksheet.Range('b3').value = [prum_bin_find[0]]
worksheet.Range('c3').value = [prum_bin_find[1]]
worksheet.Range('d3').value = [prum_bin_find[2]]
worksheet.Range('e3').value = [prum_bin_find[3]]
worksheet.Range('f3').value = [prum_bin_find[4]]
worksheet.Range('g3').value = [prum_bin_find[5]]

worksheet.Range('b4').value = [prum_int_find[0]]
worksheet.Range('c4').value = [prum_int_find[1]]
worksheet.Range('d4').value = [prum_int_find[2]]
worksheet.Range('e4').value = [prum_int_find[3]]
worksheet.Range('f4').value = [prum_int_find[4]]
worksheet.Range('g4').value = [prum_int_find[5]]

worksheet.Range('b5').value = [prum_delete[0]]
worksheet.Range('c5').value = [prum_delete[1]]
worksheet.Range('d5').value = [prum_delete[2]]
worksheet.Range('e5').value = [prum_delete[3]]
worksheet.Range('f5').value = [prum_delete[4]]
worksheet.Range('g5').value = [prum_delete[5]]

#Mediany
worksheet.Range('b6').value = [med_insert[0]]
worksheet.Range('c6').value = [med_insert[1]]
worksheet.Range('d6').value = [med_insert[2]]
worksheet.Range('e6').value = [med_insert[3]]
worksheet.Range('f6').value = [med_insert[4]]
worksheet.Range('g6').value = [med_insert[5]]

worksheet.Range('b7').value = [med_bin_find[0]]
worksheet.Range('c7').value = [med_bin_find[1]]
worksheet.Range('d7').value = [med_bin_find[2]]
worksheet.Range('e7').value = [med_bin_find[3]]
worksheet.Range('f7').value = [med_bin_find[4]]
worksheet.Range('g7').value = [med_bin_find[5]]

worksheet.Range('b8').value = [med_int_find[0]]
worksheet.Range('c8').value = [med_int_find[1]]
worksheet.Range('d8').value = [med_int_find[2]]
worksheet.Range('e8').value = [med_int_find[3]]
worksheet.Range('f8').value = [med_int_find[4]]
worksheet.Range('g8').value = [med_int_find[5]]

worksheet.Range('b9').value = [med_delete[0]]
worksheet.Range('c9').value = [med_delete[1]]
worksheet.Range('d9').value = [med_delete[2]]
worksheet.Range('e9').value = [med_delete[3]]
worksheet.Range('f9').value = [med_delete[4]]
worksheet.Range('g9').value = [med_delete[5]]
#Zbytky po polích
worksheet.Range('b10').value = [prum_zb_insert[0]]
worksheet.Range('c10').value = [prum_zb_insert[1]]
worksheet.Range('d10').value = [prum_zb_insert[2]]
worksheet.Range('e10').value = [prum_zb_insert[3]]
worksheet.Range('f10').value = [prum_zb_insert[4]]
worksheet.Range('g10').value = [prum_zb_insert[5]]

worksheet.Range('b11').value = [med_zb_insert[0]]
worksheet.Range('c11').value = [med_zb_insert[1]]
worksheet.Range('d11').value = [med_zb_insert[2]]
worksheet.Range('e11').value = [med_zb_insert[3]]
worksheet.Range('f11').value = [med_zb_insert[4]]
worksheet.Range('g11').value = [med_zb_insert[5]]

worksheet.Range('b12').value = [prum_zb_delete[0]]
worksheet.Range('c12').value = [prum_zb_delete[1]]
worksheet.Range('d12').value = [prum_zb_delete[2]]
worksheet.Range('e12').value = [prum_zb_delete[3]]
worksheet.Range('f12').value = [prum_zb_delete[4]]
worksheet.Range('g12').value = [prum_zb_delete[5]]

worksheet.Range('b13').value = [med_zb_delete[0]]
worksheet.Range('c13').value = [med_zb_delete[1]]
worksheet.Range('d13').value = [med_zb_delete[2]]
worksheet.Range('e13').value = [med_zb_delete[3]]
worksheet.Range('f13').value = [med_zb_delete[4]]
worksheet.Range('g13').value = [med_zb_delete[5]]


workbook.SaveAs(@cesta+'\sorting.xls')
workbook.Close
excel.Quit
puts "proběhlo zapsání do souboru"
end

def vysledky_tree
excel = WIN32OLE:: new('excel.Application')
workbook = excel.Workbooks.Open(@cesta+'\sorting.xls')
worksheet = workbook.Worksheets(3)
worksheet.Select
# Připravení hlavičky výsledného xls
worksheet.Range('a2').value = ["Insert prumer"]
worksheet.Range('a3').value = ["Find prumer"]
worksheet.Range('a4').value = ["Delete prumer"]
worksheet.Range('a5').value = ["Insert median"]
worksheet.Range('a6').value = ["Find median"]
worksheet.Range('a7').value = ["Delete median"]
worksheet.Range('a8').value = ["Zbytky po insertu prumer"]
worksheet.Range('a9').value = ["Zbytky po insertu median"]
worksheet.Range('a10').value = ["Zbytky po deletu prumer"]
worksheet.Range('a11').value = ["Zbytek po deletu median"]

worksheet.Range('b1').value = ['(10:10000)']
worksheet.Range('c1').value = ['(50:1000)']
worksheet.Range('d1').value = ["(100:500)"]
worksheet.Range('e1').value = ["(500:50)"]
worksheet.Range('f1').value = ["(1000:10)"]
worksheet.Range('g1').value = ["(5000:10)"]
#Zapsání prumer jednotlivych dvojic do tabulky
prum_insert = []
prum_find = []
prum_delete = []
pole1=[]
pole2=[]
pole3=[]
@dvojce.each do |n,m|
 for i in 0..(@tree.length-1) do
   if (@tree[i][1]== n)
     pole1 << @tree[i][3]
     pole2 << @tree[i][4]
     pole3 << @tree[i][5]
   end
 end
end
for b in 0..5 do
  prum_insert << prumer(pole1[0,@mereni.to_i])
  for a1 in 0..(@mereni.to_i-1)
    pole1.delete_at(a1)
  end
end
for c in 0..5 do
  prum_find << prumer(pole2[0,@mereni.to_i])
  for a2 in 0..(@mereni.to_i-1)
    pole2.delete_at(a2)
  end
end
for d in 0..5 do
  prum_delete << prumer(pole3[0,@mereni.to_i])
  for a3 in 0..(@mereni.to_i-1)
    pole3.delete_at(a3)
  end
end

#Zapsání medianu jednotlivych dvojic do tabulky
med_insert = []
med_find = []
med_delete = []
pole4=[]
pole5=[]
pole6=[]
@dvojce.each do |n,m|
 for i in 0..(@tree.length-1) do
   if (@tree[i][1]== n)
     pole4 << @tree[i][3]
     pole5 << @tree[i][4]
     pole6 << @tree[i][5]
   end
 end
end
for e in 0..5 do
  med_insert << median(pole4[0,@mereni.to_i])
  for a4 in 0..(@mereni.to_i-1)
    pole4.delete_at(a4)
  end
end
for f in 0..5 do
  med_find << median(pole5[0,@mereni.to_i])
  for a5 in 0..(@mereni.to_i-1)
    pole5.delete_at(a5)
  end
end
for g in 0..5 do
  med_delete << median(pole6[0,@mereni.to_i])
  for a6 in 0..(@mereni.to_i-1)
    pole6.delete_at(a6)
  end
end

#Zapsani zbytku(součet všech medianu a prumeru v jednotlivych opakovaních)
med_zb_insert = []
med_zb_delete = []
prum_zb_insert = []
prum_zb_delete = []
pole7=[]
pole8=[]
pole9=[]
pole10=[]
@dvojce.each do |n,m|
 for i in 0..(@tree.length-1) do
   if (@tree[i][1]== n)
     pole7 << @tree[i][6]#ins prumer
     pole8 << @tree[i][7]#ins media
     pole9 << @tree[i][8]#del prumer
     pole10 << @tree[i][9]#del median
   end
 end
end
for h in 0..5 do
  prum_zb_insert << prumer(pole7[0,@mereni.to_i])
  for a7 in 0..(@mereni.to_i-1)
    pole7.delete_at(a7)
  end
end
for i in 0..5 do
  med_zb_insert << median(pole8[0,@mereni.to_i])
  for a8 in 0..(@mereni.to_i-1)
    pole8.delete_at(a8)
  end
end
for j in 0..5 do
  prum_zb_delete << prumer(pole9[0,@mereni.to_i])
  for a9 in 0..(@mereni.to_i-1)
    pole9.delete_at(a9)
  end
end
for k in 0..5 do
  med_zb_delete << median(pole10[0,@mereni.to_i])
  for a10 in 0..(@mereni.to_i-1)
    pole10.delete_at(a10)
  end
end
#Vytvoreni tabulky
worksheet.Range('b2').value = [prum_insert[0]]
worksheet.Range('c2').value = [prum_insert[1]]
worksheet.Range('d2').value = [prum_insert[2]]
worksheet.Range('e2').value = [prum_insert[3]]
worksheet.Range('f2').value = [prum_insert[4]]
worksheet.Range('g2').value = [prum_insert[5]]

worksheet.Range('b3').value = [prum_find[0]]
worksheet.Range('c3').value = [prum_find[1]]
worksheet.Range('d3').value = [prum_find[2]]
worksheet.Range('e3').value = [prum_find[3]]
worksheet.Range('f3').value = [prum_find[4]]
worksheet.Range('g3').value = [prum_find[5]]

worksheet.Range('b4').value = [prum_delete[0]]
worksheet.Range('c4').value = [prum_delete[1]]
worksheet.Range('d4').value = [prum_delete[2]]
worksheet.Range('e4').value = [prum_delete[3]]
worksheet.Range('f4').value = [prum_delete[4]]
worksheet.Range('g4').value = [prum_delete[5]]

  #Mediany
worksheet.Range('b5').value = [med_insert[0]]
worksheet.Range('c5').value = [med_insert[1]]
worksheet.Range('d5').value = [med_insert[2]]
worksheet.Range('e5').value = [med_insert[3]]
worksheet.Range('f5').value = [med_insert[4]]
worksheet.Range('g5').value = [med_insert[5]]

worksheet.Range('b6').value = [med_find[0]]
worksheet.Range('c6').value = [med_find[1]]
worksheet.Range('d6').value = [med_find[2]]
worksheet.Range('e6').value = [med_find[3]]
worksheet.Range('f6').value = [med_find[4]]
worksheet.Range('g6').value = [med_find[5]]

worksheet.Range('b7').value = [med_delete[0]]
worksheet.Range('c7').value = [med_delete[1]]
worksheet.Range('d7').value = [med_delete[2]]
worksheet.Range('e7').value = [med_delete[3]]
worksheet.Range('f7').value = [med_delete[4]]
worksheet.Range('g7').value = [med_delete[5]]
#Zbytky po polích
worksheet.Range('b8').value = [prum_zb_insert[0]]
worksheet.Range('c8').value = [prum_zb_insert[1]]
worksheet.Range('d8').value = [prum_zb_insert[2]]
worksheet.Range('e8').value = [prum_zb_insert[3]]
worksheet.Range('f8').value = [prum_zb_insert[4]]
worksheet.Range('g8').value = [prum_zb_insert[5]]

worksheet.Range('b9').value = [med_zb_insert[0]]
worksheet.Range('c9').value = [med_zb_insert[1]]
worksheet.Range('d9').value = [med_zb_insert[2]]
worksheet.Range('e9').value = [med_zb_insert[3]]
worksheet.Range('f9').value = [med_zb_insert[4]]
worksheet.Range('g9').value = [med_zb_insert[5]]

worksheet.Range('b10').value = [prum_zb_delete[0]]
worksheet.Range('c10').value = [prum_zb_delete[1]]
worksheet.Range('d10').value = [prum_zb_delete[2]]
worksheet.Range('e10').value = [prum_zb_delete[3]]
worksheet.Range('f10').value = [prum_zb_delete[4]]
worksheet.Range('g10').value = [prum_zb_delete[5]]

worksheet.Range('b11').value = [med_zb_delete[0]]
worksheet.Range('c11').value = [med_zb_delete[1]]
worksheet.Range('d11').value = [med_zb_delete[2]]
worksheet.Range('e11').value = [med_zb_delete[3]]
worksheet.Range('f11').value = [med_zb_delete[4]]
worksheet.Range('g11').value = [med_zb_delete[5]]

workbook.SaveAs(@cesta+'\sorting.xls')
workbook.Close
excel.Quit
puts "proběhlo zapsání do souboru"
end

  #Metoda sloužící pro vrácení průměru pro pole.
  def prumer(array)
    total = 0
    array.each do |value|
      total += value
    end
    return (total/array.size)
  end

  #Metoda vypočítávající median hodnot vlkožených do pole.
  def median(array)
    pole = array.sort
    median = 0
    if (array.length % 2 == 0)
      median = (pole[array.length / 2] + pole[(array.length / 2)-1])/2
    else
      median = pole[array.length / 2]
    end
    return median
  end
 
end

x = SearchingBenchmark.new
x.benchmark
x.vysledky_unsorted
x.vysledky_sorted
x.vysledky_tree


