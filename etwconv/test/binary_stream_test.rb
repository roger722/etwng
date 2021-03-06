require "test/unit"

require "lib/binary_stream"

class TestBinaryStream < Test::Unit::TestCase
  def test_empty
    s = BinaryStreamReader.new("")
    assert_equal 0, s.size
    assert s.eof?
    assert_raises(BinaryStreamException) { s.u4 }
  end

  def test_u4s
    s = BinaryStreamReader.new([13,500].pack("VV"))
    assert_equal 8, s.size
    assert !s.eof?
    assert_equal 13, s.u4
    assert !s.eof?
    assert_equal 500, s.u4
    assert s.eof?
    assert_raises(BinaryStreamException) { s.u4 }
  end

end