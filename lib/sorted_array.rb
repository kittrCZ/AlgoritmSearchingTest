# Represents an ordered array.
# Provides methods for adding objects, removing them and searching for them.
class SortedArray

  # Creates a new, empty instance.
  def initialize
    @inner = Array.new
  end

  def length
    return @inner.length
  end
  # Searches for +value+ using binary search.
  # Returns index of +value+ in the array or -1 if +value+ is not found.
  def binary_search(value)
    search_result = binary_search_internal(value)
    return search_result[0]? search_result[1] : -1
  end

  # Searches for +value+ using binary search.
  # Returns index of +value+ in the array or -1 if +value+ is not found.
  def interpolation_search(value)
    search_result = interpolation_search_internal(value)
    return search_result[0]? search_result[1] : -1
  end

  # Inserts +value+ into +self+. If +value+ is already there, this method does nothing.
  # Returns index of +value+.
  def insert(value)
    search_result = binary_search_internal(value)
    unless search_result[0]
      @inner.length.downto(search_result[1] + 1) { |i| @inner[i] = @inner[i - 1] }
      @inner[search_result[1]] = value
    end
    return search_result[1]
  end

  # Deletes +value+ from +self+. If +self+ doesn't contain +value+, this method does nothing.
  # Returns +true+ if +value+ was deleted, returns false if +value+ was not found.
  def delete(value)
    index = binary_search(value)
    return false if index == -1
    index.upto(@inner.length - 2) { |i| @inner[i] = @inner[i + 1] }
   @inner.delete_at(@inner.length - 1)
    return true
  end

  # Converts self into a regular +Array+.
  def to_a
    return @inner.clone
  end

  private

  # Searches for +value+ using binary search. Only for internal use, shouldn't be used outside this class.
  # Returns a two-item array. If +value+ is found, returns +[true, index]+ where +index+ is the index of +value+.
  # Otherwise, returns +[false, index]+ where +index+ is the index to which +value+ could be inserted
  # (keeping the array sorted).
  def binary_search_internal(value)
    return [false, 0] if @inner.size == 0
    left = 0
    right = @inner.size - 1
    return [false, 0] if value < @inner[left]
    return [false, right + 1] if value > @inner[right]
    while left <= right
      middle = (left + right) / 2
      if @inner[middle] == value
        return [true, middle]
      elsif value < @inner[middle]
        right = middle - 1
      else
        left = middle + 1
      end
    end
    return [false, left]
  end

  # Searches for +value+ using interpolation search. Only for internal use, shouldn't be used outside this class.
  # Returns a two-item array. If +value+ is found, returns +[true, index]+ where +index+ is the index of +value+.
  # Otherwise, returns +[false, index]+ where +index+ is the index to which +value+ could be inserted
  # (keeping the array sorted).
  def interpolation_search_internal(value)
    return [false, 0] if @inner.size == 0
    left = 0
    right = @inner.size - 1
    return [false, 0] if value < @inner[left]
    return [false, right + 1] if value > @inner[right]
    while left <= right
      if left == right
        candidate = left
      else
        candidate = (left + (right - left) * (value - @inner[left]) / (@inner[right] - @inner[left]).to_f).round
      end
      return [false, left] if candidate < left
      return [false, right + 1] if candidate > right
      if @inner[candidate] == value
        return [true, candidate]
      elsif value < @inner[candidate]
        right = candidate - 1
      else
        left = candidate + 1
      end
    end
    return [false, left]
  end

end
