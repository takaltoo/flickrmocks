module FlickrMocks
  module Helpers

    class << self
      def extension
        ".marshal"
      end

      def fname_fixture(symbol)
        raise RunTimeError unless symbol.is_a? Symbol
        symbol.to_s + extension
      end

      def equivalent?(a,b)
        return false if a.class != b.class
        case a
        when FlickRaw::Response,FlickRaw::ResponseList then a.methods(false).collect do |m|
            b.respond_to?(m) ? equivalent?(a.send(m),b.send(m)) : false
          end.inject(true) {|r1,r2| r1 && r2}

        when Hash then a.keys.collect  do |k|
            b.has_key?(k) ? equivalent?(a[k],b[k]) : false
          end.inject(true){|r1,r2| r1 && r2}

        when Array then a.each_with_index.collect do |v,i|
            b.length == a.length ? equivalent?(v,b[i]) : false
          end.inject(true) {|r1,r2| r1 && r2}
        else
          a == b
        end
      end

      def dump(response,file)
        begin
          f  = File.open(file,'w')
          f.write Marshal.dump(response)
        ensure
          f.close
        end
      end

      def load(file)
        begin
          f=File.open(file,'r')
          Marshal.load(f)
        ensure
          f.close
        end
      end
    end
  end
end
