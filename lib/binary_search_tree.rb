# -*- coding: utf-8 -*-
# Contains implementation of a simple binary search tree.
# All vertices (both inner vertices and leaves) are represented by the class Vertex.
class BinarySearchTree

  attr_reader :root

  # Creates empty tree.
  def initialize
    @root = Vertex.new([nil, nil])
    @size = 0
  end

  def length
    return @size
  end
  # Searches for +x+. Returns +Vertex+ containing +x+ or +nil+ if +x+ is not found.
  def find(x)
    node = search_for(x)
    return (node.value != nil) ? node : nil
  end

  # Inserts +x+ into +self+. If +x+ is already there, this method does nothing.
  # Returns +Vertex+ containing +x+.
  def insert(x)
    node = search_for(x)
    if node.value.nil?
      left = Vertex.new([node.interval[0], x])
      right = Vertex.new([x, node.interval[1]])
      node.left = left
      node.right = right
      left.parent = node
      right.parent = node
      node.interval = nil
      node.value = x
      @size +=1
    end
    return node
  end

  # Deletes +x+ from +self+. If +self+ doesn't contain +x+, this method does nothing.
  # Returns +true+ if +x+ was deleted, returns false if +x+ was not found.
  def delete(x)
    node = search_for(x)
    if node.value != nil # we found x
      if node.left.value == nil # node.left is leaf
        left_edge = node.left.interval[0]
        node = delete_special(node, node.left)
        # update the leftest interval in the subtree of the right-side child of the original node
        node = node.left while node.value != nil
        node.interval[0] = left_edge
      else # node.left isn't leaf
        rightest = node.left
        rightest = rightest.right while rightest.right.value != nil
        node.value = rightest.value
        delete_special(rightest, rightest.right)
        # update the leftest interval in the subtree of the right-side child of the original node
        leftest = node.right
        leftest = leftest.left while leftest.value != nil
        leftest.interval[0] = node.value
      end
      @size -=1
      return true
    end
    return false
  end

  # Returns linearized string representation of +self+.
  def to_s
    @root.to_subtree_s
  end

  private

  # Only for internal use, shouldn't be used outside this class.
  # Searches for value +x+ and returns either inner vertex holding +x+
  # or leaf holding interval containing +x+.
  def search_for(x)
    node = @root
    while node.value != x && node.value != nil
      node = (x < node.value) ? node.left : node.right
    end
    return node
  end

  # Only for internal use, shouldn't be used outside this class.
  # Deletes +x+, using its child +y+. Requirements: +y+ is child of +x+,
  # +y+ is leaf (otherwise this method's behavior is undefined).
  # Returns +Vertex+ which takes +x+'s places in the tree.
  def delete_special(x, y)
    # precondition: y is child of x, y is leaf
    z = (x.left == y) ? x.right : x.left # let z be the other child of x
    if x != @root # z isn't root
      z.parent = x.parent
      if x == x.parent.right
        x.parent.right = z
      else
        x.parent.left = z
      end
    else # z is root
      z.parent = nil
      @root = z
    end
    return z
  end

  public

  # Constants used in to_svg method.

  # Left offset of the tree in the whole SVG picture.
  START_LEFT = 0
  # Height of one level of the tree.
  LEVEL_HEIGHT = 60
  # Width of a node representing an interval.
  INTERVAL_WIDTH = 68
  # Width of a node representing a value.
  VALUE_WIDTH = 40
  # Height of a node
  NODE_HEIGHT = 24
  # "Magical" vertical offset that makes text inside nodes "better vertically centered".
  MAGICAL_OFFSET = 7
  # Horizontal space between two nodes that are horizontally "next to each other".
  HORIZONTAL_SPACE = 12

  # Saves SVG representation of +self+ into +filename+.
  # The picture is then best viewed in Inkscape.
  def to_svg(filename)
    File.open(filename, "w") { |f|
      f.puts '<?xml version="1.0" encoding="utf-8"?>'
      f.puts '<svg xmlns="http://www.w3.org/2000/svg">'
      f.puts @root.to_svg(START_LEFT, 0)[0]
      f.puts '</svg>'
    }
  end

end

# Represents a single vertex of a binary search tree.
class Vertex

  attr_accessor :left, :right, :parent, :value, :interval

  # Creates a vertex. +value+ is either an object being inserted into
  # a binary search tree or a two-item array representing an interval.
  # This method should be used only from within the +BinarySearchTree+ class.
  def initialize(value)
    @left = nil
    @right = nil
    @parent = nil
    if value.instance_of? Array
      @interval = value
      @value = nil
    else
      @value = value
      @interval = nil
    end
  end

  # Returns string representation of self.
  def to_s
    return @value ? "#{@value}" : "(#{@interval[0]},#{@interval[1]})"
  end

  # Returns linearized string representation of self and all its children.
  def to_subtree_s
    s = ""
    if @value != nil
      s << @value.to_s
      if @left.value != nil || @right.value != nil
        s << "(" << @left.to_subtree_s << "," << @right.to_subtree_s << ")"
      end
    end
    return s
  end

  # Builds (in the form of string) SVG representation of +self+ and all its children.
  #  left: left offset of the leftest node in the whole subtree
  #  level: level in the tree (root has a level of 0)
  # Returns three-item array, the first item being SVG string itself. The other two
  # items are needed for recursion. The second item is a horizontal offset of the center of +self+
  # (used for drawing of edges). The third item is a horizontal offset representing the rightest
  # point used when drawing +self+'s whole subtree.
  def to_svg(left, level)
    # y offset of self
    y = (level + 0) * BinarySearchTree::LEVEL_HEIGHT + BinarySearchTree::MAGICAL_OFFSET + BinarySearchTree::NODE_HEIGHT / 2.0
    svg = ''
    if @value.nil? # self represents an interval
      # string representation of the left bound
      left_edge = @interval[0].nil? ? "−∞" : (@interval[0] < 0 ? "−#{-@interval[0]}" : @interval[0])
      # string representation of the right bound
      right_edge = @interval[1].nil? ? "∞" : (@interval[1] < 0 ? "−#{-@interval[1]}" : @interval[1])
      # textual representation of the interval
      svg += "  <text x=\"#{left + BinarySearchTree::INTERVAL_WIDTH / 2.0}\" y=\"#{y}\" style=\"text-anchor: middle; font-size: 20;\">#{left_edge},#{right_edge}</text>\n"
      # rectangle around the interval
      svg += "  <rect x=\"#{left}\" y=\"#{y - BinarySearchTree::MAGICAL_OFFSET - BinarySearchTree::NODE_HEIGHT / 2.0}\" width=\"#{BinarySearchTree::INTERVAL_WIDTH}\" height=\"#{BinarySearchTree::NODE_HEIGHT}\" style=\"fill: none; stroke: black; stroke-width: 2;\"/>\n"
      return [svg, left + BinarySearchTree::INTERVAL_WIDTH / 2.0, left + BinarySearchTree::INTERVAL_WIDTH]
    else # self represents a value
      # recursion for the left child
      left_svg, center, right = @left.to_svg(left, level + 1)
      svg += left_svg
      # horizontal offset around which self's text and rectangle will be centered
      text_center = right + BinarySearchTree::HORIZONTAL_SPACE / 2.0
      # edge to the left child
      svg += "  <line x1=\"#{text_center}\" y1=\"#{y - BinarySearchTree::MAGICAL_OFFSET + BinarySearchTree::NODE_HEIGHT / 2.0}\" x2=\"#{center}\" y2=\"#{y - BinarySearchTree::MAGICAL_OFFSET - BinarySearchTree::NODE_HEIGHT / 2.0 + BinarySearchTree::LEVEL_HEIGHT}\" style=\"stroke-width: 2; stroke: black;\"/>\n"
      # string representation of the value
      val = @value < 0 ? "−#{-@value}" : @value
      # textual representation of the value
      svg += "  <text x=\"#{text_center}\" y=\"#{y}\" style=\"text-anchor: middle; font-size: 20;\">#{val}</text>\"\n"
      # rounded rectangle around the value
      svg += "  <rect x=\"#{text_center - BinarySearchTree::VALUE_WIDTH / 2.0}\" y=\"#{y - BinarySearchTree::MAGICAL_OFFSET - BinarySearchTree::NODE_HEIGHT / 2.0}\" width=\"#{BinarySearchTree::VALUE_WIDTH}\" height=\"#{BinarySearchTree::NODE_HEIGHT}\" rx=\"20\" ry=\"20\" style=\"fill: none; stroke: black; stroke-width: 2;\"/>\n"
      # recursion for the right child
      right_svg, center, right = @right.to_svg(right + BinarySearchTree::HORIZONTAL_SPACE, level + 1)
      #edghe to the right child
      svg += "  <line x1=\"#{text_center}\" y1=\"#{y - BinarySearchTree::MAGICAL_OFFSET + BinarySearchTree::NODE_HEIGHT / 2.0}\" x2=\"#{center}\" y2=\"#{y - BinarySearchTree::MAGICAL_OFFSET - BinarySearchTree::NODE_HEIGHT / 2.0 + BinarySearchTree::LEVEL_HEIGHT}\" style=\"stroke-width: 2; stroke: black;\"/>\n"
      svg += right_svg
      return [svg, text_center, right]
    end
  end
end
