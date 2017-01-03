ColorCategory = Struct.new(:name, :colors)

Color = Struct.new(:name, :code) do
  def name_with_code
    "#{name} (#{code})"
  end

  def self.all
    [
      new("Red", "#f00"),
      new("Green", "#0f0"),
      new("Blue", "#00f")
    ]
  end

  def self.categorized
    [
      ColorCategory.new("Primary", [
        new("Red", "#f00"),
        new("Green", "#0f0"),
        new("Blue", "#00f")
      ]),

      ColorCategory.new("Secondary", [
        new("Yellow", "#ff0"),
        new("Magenta", "#f0f"),
        new("Cyan", "#0ff")
      ])
    ]
  end
end
