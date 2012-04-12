# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'sorted_array'

class SortedArrayTest < Test::Unit::TestCase
  def test_insert
    pole = SortedArray.new
    for i in 1..10 do
          assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
          assert_equal i-1, pole.insert(i)
    end
    
  end

  def test_find_interpolation
    pole = SortedArray.new
    for i in 1..10 do
      assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
      assert i-1,pole.interpolation_search(i)
    end
    
  end

  def test_find_binary
    pole = SortedArray.new
    for i in 1..10 do
      assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
      assert i-1,pole.binary_search(i)
    end

  end

  def test_delete
    pole = SortedArray.new
    for i in 1..10 do
      assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
      assert_equal true, pole.delete(i)
    end
  end
def test_insert_nahodny
pole = SortedArray.new
test = Array.new
for l in 0..100 do
  test[l] = false
end
for j in 0..100 do
   a = rand(100)
   pole.insert(a)
   test[a] = true
end

for k in 0..100 do
  if test[k] == true
    assert_not_equal(-1, pole.interpolation_search(k))
  else
    assert_equal (-1, pole.interpolation_search(k))
  end
end
end
def test_find_nahodny
pole = SortedArray.new
test = Array.new

for l in 0..100 do
  test[l] = false
end

for q in 0..100 do
     a = rand(100)
     pole.insert(a)
     test[a] = true
end

for w in 0..100 do
  if test[w] == true
      assert_not_equal -1, pole.binary_search(w)
    else
      assert_equal -1, pole.binary_search(w)
  end
end
end

def test_delete_nahodny
pole = SortedArray.new
test = Array.new
for l in 0..100 do
  test[l] = false
end
for j in 0..100 do
    a = rand(100)
    pole.insert(a)
    test[a] = true
end
  for m in 0..100 do
   if test[m] == true
     assert_equal true, pole.delete(m)
   else
     assert_equal false, pole.delete(m)
   end
  end
end
end
