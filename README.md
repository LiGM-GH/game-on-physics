# Game On Physics
The main idea is to make a program which will be able to use real physical quantities in game development.

## Imagine a world...
where you can't get stuck in an object!
It would be perfect, right?

## We want to make it!
We want our tool to be like:
- you make a measure
- you make a physical quantity
- you declare their relations
- you get a full-power physic, like

```Ruby
  Quantity.make(:Power) do
    has_measure :Newtons
    vector_value
  end

  Quantity.make :Pressure do
    has_measure :Pascals
    scalar_value
  end

  Quantity.declare_dependency(Pressure: [:Power, :Area]) do |pressure, power, area|
    pressure = power.value / area
  end
```

To feel this better, look at RBS:

```Ruby
    class Power < Quantity
      attr_accessor value: Newton # maybe attr_reader?
      attr_accessor angle: Radian # maybe attr_reader?
      def /: (Area) -> Pressure # Added by declare_dependency
    end

    class Newton < Measure
      def /: (Meter) -> Pascal  # Added by declare_dependency
    end

    class Pascal
      def *: (Meter) -> Newton  # Added by declare_dependency
    end

    class Pressure < Quantity
      attr_accessor value: Pascal # maybe attr_reader?
    end
```
