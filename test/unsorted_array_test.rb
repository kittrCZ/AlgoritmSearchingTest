# To change this template, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'unsorted_array'

class UnsortedArrayTest < Test::Unit::TestCase
  def test_insert
    pole = UnsortedArray.new
    for i in 1..10 do
          assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
          assert_equal i-1, pole.insert(i)
    end
 end

  def test_delete
    pole = UnsortedArray.new
    for i in 1..10 do
      assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
      assert_equal true, pole.delete(i)
    end
  end

  def test_find
    pole = UnsortedArray.new
    for i in 1..10 do
      assert_equal i-1, pole.insert(i)
    end

    for i in 1..10 do
      assert i-1,pole.find(i)
    end 
  end

def test_insert_nahodny
pole = UnsortedArray.new
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
    assert_not_equal(-1, pole.find(k))
  else
    assert_equal -1, pole.find(k)
  end
end
end

def test_find_nahodny
pole = UnsortedArray.new
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
      assert_not_equal -1, pole.find(w)
    else
      assert_equal -1, pole.find(w)
  end
end
end
def test_delete_nahodny
pole = UnsortedArray.new
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


