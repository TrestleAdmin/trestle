module Trestle
  class Color
    attr_reader :r, :g, :b

    def initialize(r, g, b)
      @r, @g, @b = r, g, b
    end

    def hex
      "##{[r, g, b].map { |i| i < 16 ? "0#{i.to_s(16)}" : i.to_s(16) }.join}"
    end

    def rgb
      [r, g, b]
    end

    def hsl
      r = @r / 255.0
      g = @g / 255.0
      b = @b / 255.0

      min = [r, g, b].min
      max = [r, g, b].max

      h = s = l = (max + min) / 2.0

      if max == min
        h = 0
        s = 0
      else
        d = max - min
        s = l >= 0.5 ? d / (2 - max - min) : d / (max + min)

        case max
        when r
          h = (g - b) / d + (g < b ? 6 : 0)
        when g
          h = (b - r) / d + 2
        when b
          h = (r - g) / d + 4
        end

        h /= 6.0
      end

      [(h*360).round, (s*100).round, (l*100).round]
    end

    def self.parse(str)
      if str.starts_with?("#") && str.length.in?([4, 7])
        parse_hex(str)
      elsif str.starts_with?("rgb")
        parse_rgb(str)
      elsif str.starts_with?("hsl")
        parse_hsl(str)
      else
        raise ArgumentError, "Could not parse color code: #{str}"
      end
    end

    def self.parse_hex(str)
      str = str.sub(/^#/, "")

      if str.length == 3
        str = str[0] * 2 + str[1] * 2 + str[2] * 2
      end

      new(str[0, 2].hex, str[2, 2].hex, str[4, 2].hex)
    end

    def self.parse_rgb(str)
      match = str.match(/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/)
      new(match[1].to_i, match[2].to_i, match[3].to_i)
    end

    def self.parse_hsl(str)
      match = str.match(/^hsl\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/)
      h, s, l = match[1].to_f, match[2].to_f, match[3].to_f

      h /= 360
      s /= 100
      l /= 100

      if s == 0
        r = g = b = l.to_f
      else
        q = l < 0.5 ? l * (1 + s) : l + s - l * s
        p = 2 * l - q

        r = hue_to_rgb(p, q, h + 1/3.0)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1/3.0)
      end

      new((r * 255).round, (g * 255).round, (b * 255).round)
    end

    def self.hue_to_rgb(p, q, t)
      t += 1 if t < 0
      t -= 1 if t > 1

      if t < 1 / 6.0
        p + (q - p) * 6 * t
      elsif t < 1 / 2.0
        q
      elsif t < 2 / 3.0
        p + (q - p) * (2 / 3.0 - t) * 6
      else
        p
      end
    end
  end
end
