# Represents a simple structure capable of inserting objects, deleting them and searching for them.
class UnsortedArray

  # Creates a new, empty instance.
  def initialize
    @inner = Array.new
  end

  def length
    return @inner.length
  end
  # Searches for +value+ in +self+.
  # Returns index of +value+ in the array or -1 if +value+ is not found.
  def find(value)
    result = -1
    @inner.each_with_index { |item, index|
      if value == item
        result = index
        break
      end
    }
    return result
  end

  # Inserts +value+ into +self+. If +value+ is already there, this method does nothing.
  # Returns index of +value+.
  def insert(value)
    index = find(value)
    if index == -1
      @inner << value
      index = @inner.length - 1
    end
    return index
  end

  # Deletes +value+ from +self+. If +self+ doesn't contain +value+, this method does nothing.
  # Returns +true+ if +value+ was deleted, returns false if +value+ was not found.
  def delete(value)
    index = find(value)
    return false if index == -1
    @inner[index] = @inner[@inner.length - 1]
    @inner.delete_at(@inner.length - 1)
    return true
  end

  # Converts self into a regular +Array+.
  def to_a
    return @inner.clone
  end
end
