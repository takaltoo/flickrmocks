require 'ruby-debug'

module FlickrMocks
  module Helpers

    class << self
      def extension
        ".marshal"
      end

      def fname_photo(photo)
        id = photo.respond_to?(:photo_id) ? photo.photo_id : photo.id
        ['photo','id',id].join('_') + extension
      end

      def fname_photos(options)
        base = options[:tags].downcase.split(',').map {|value| value.strip}.sort.join('_')
        perpage = options[:perpage].nil? ? nil : ['perpage',options[:perpage].to_s].join('_')
        page = options[:page].nil? ? nil : ['page',options[:page].to_s].join('_')
        tag_mode = options[:tag_mode].nil? ? nil : ['tagmode',options[:tag_mode].to_s].join('_')
        ['photos',base,perpage,page,tag_mode].find_all {|tag| !tag.nil?}.join('_') + extension
      end


      def fname_sizes(photo)
        ['sizes',fname_photo(photo)].join('_')
      end

      def compare(a,b)
        return false if a.class != b.class
        case a
        when FlickRaw::Response,FlickRaw::ResponseList then a.methods(false).collect do |m|
            b.respond_to?(m) ? compare(a.send(m),b.send(m)) : false
          end.inject(true) {|r1,r2| r1 && r2}

        when Hash then a.keys.collect  do |k|
            b.has_key?(k) ? compare(a[k],b[k]) : false
          end.inject(true){|r1,r2| r1 && r2}

        when Array then a.each_with_index.collect do |v,i|
            b.length == a.length ? compare(v,b[i]) : false
          end.inject(true) {|r1,r2| r1 && r2}
        else
          a == b
        end
      end

      def marshal(response,file)
        begin
          f  = File.open(file,'w')
          f.write Marshal.dump(response)
        ensure
          f.close
        end
      end

      def unmarshal(file)
        begin
          f=File.open(file,'r')
          Marshal.load(f)
        ensure
          f.close
        end
      end

    def marshal_flickraw(obj)
      r = {}
      obj.methods(false).each do |k|
        v = obj.send k.to_sym
        r[k.to_s] = case v
        when Array then v.collect {|e| marshal_flickraw(e)}
        when FlickRaw::Response then marshal_flickraw(v)
        when FlickRaw::ResponseList then marshal_flickraw(v)
        else v
        end
      end
      r
    end

    end
  end
end
