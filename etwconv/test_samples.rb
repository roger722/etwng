puts "Testing #{RUBY_PLATFORM}/#{RUBY_VERSION}"
$: << "."

require "lib/core_ext"
require "lib/file_format_detection"
require "test/unit"

class TestSamples < Test::Unit::TestCase
  def ffd
    @ffd = FileFormatDetection.new("samples")
  end
  
  def hexdump(label, data)
    rows = ["#{label} #{data.size} bytes\n"]
    16.times{|i|
      bytes = data[16*i,16].unpack("C*")
      break if bytes.nil?
      rows << bytes.map{|x| "%02X" % x}.join(" ") + "\n"
    }
    rows.join
  end

  def assert_converts(fn)
    conv = ffd.converter_for(fn)
    return unless conv
    
    orig = File.read(fn)
    data = conv.unpack(File.read(fn))
    back = conv.pack(data)
    if back == orig
      assert true
    else
      assert false, "Conversion of #{fn} should round trip correctly\n" + hexdump("New", back) + hexdump("Original", orig)
    end
  end

  Dir["samples/*"].sort.each{|fn|
    name = File.basename(fn).tr(".-","__")
    eval "def test_#{name}; assert_converts(#{fn.inspect}); end"
  }
end