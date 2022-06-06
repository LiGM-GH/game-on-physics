TODO:
- make PhysicalQuantity class
- make a CLI tool for making physical quantities
  - `$ physic generate quantity QUANTITY`
  - `$ physic g quantity QUANTITY`
- determine a format of unit-makefiles (like JSON, HTML, YAML).
  - make my own ActiveRecord-like DSL for declaring dependencies:
    ```Ruby
      Quantity.declare_dependency A:  [:B, :C] do |a, b, c|
        a = b.scalarly_multiply(c)
      end # Declares b*c type to be A
    ```
