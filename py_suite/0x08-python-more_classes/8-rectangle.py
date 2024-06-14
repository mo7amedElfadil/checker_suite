#!/usr/bin/python3
#!/usr/bin/python3
""" Rectangle module """


class Rectangle:
    """Definition of Rectangle Class
        Args:
        width (int) Optional, 0 by default.
        height (int) Optional, 0 by default.

    Attributes:
        width (int, private): width of Rectangle, 0 by default.
        height (int, private): height of Rectangle, 0 by default.
    Methods:
        area (Public): returns area (int) of the instance Rectangle
        perimeter (Public): returns perimeter (int) of the instance Rectangle
        width: property setter and getter
        height: property setter and getter
            Args:
            value: value of width/height
            if value meets the requirements mentioned in method doc.
        update_number_of_instances (class method): called in constructor or
            destructor to increment or decrement no. of rectangle instances

    """
    number_of_instances = 0
    print_symbol = "#"

    def __init__(self, width=0, height=0):
        """Function to initialize instance of Rectangle
        Attributes:
        width (int, private): width of Rectangle, 0 by default.
        height (int, private): height of Rectangle, 0 by default.

        """
        self.width = width
        self.height = height
        Rectangle.update_number_of_instances(1)

    @classmethod
    def update_number_of_instances(cls, i):
        """class method that updates number_of_instances of Rectangle Class"""
        cls.number_of_instances += i

    @property
    def width(self):
        """getter for width property"""
        return self.__width

    @width.setter
    def width(self, value):
        """setter for width property
             if width < 0 --> raise ValueError with
            msg : width must be >= 0.
            if width is not integer --> raise TypeError with
            msg : width must be an integer.

        """
        if not isinstance(value, int):
            raise TypeError("width must be an integer")
        elif value < 0:
            raise ValueError("width must be >= 0")
        self.__width = value

    @property
    def height(self):
        """getter for height property"""
        return self.__height

    @height.setter
    def height(self, value):
        """setter for height property
             if height < 0 --> raise ValueError with
            msg : height must be >= 0.
            if height is not integer --> raise TypeError with
            msg : height must be an integer.

        """
        if not isinstance(value, int):
            raise TypeError("height must be an integer")
        elif value < 0:
            raise ValueError("height must be >= 0")
        self.__height = value

    def area(self):
        """returns area of Rectangle"""
        return self.width * self.height

    def perimeter(self):
        """returns perimeter of Rectangle"""
        if 0 in [self.width, self.height]:
            return 0
        return 2 * (self.width + self.height)

    def __str__(self):
        """returns str representation of Rectangle"""
        rect = ""
        if 0 in [self.width, self.height]:
            return rect
        for _ in range(self.height):
            rect += (str(self.print_symbol) * self.width +
                        ("\n", "")[_ == self.height - 1])
        return rect

    def __repr__(self):
        """returns representation of Rectangle Instance"""
        return "Rectangle(" + str(self.width) + ", " + str(self.height) + ")"

    def __del__(self):
        """deconstructor of Rectangle Instance"""
        Rectangle.update_number_of_instances(-1)
        print("Bye rectangle...")

    @staticmethod
    def bigger_or_equal(rect_1, rect_2):
        """static method to compare areas of 2 Instances of Rectangle class:"""
        if not isinstance(rect_1, Rectangle):
            raise TypeError("rect_1 must be an instance of Rectangle")
        if not isinstance(rect_2, Rectangle):
            raise TypeError("rect_2 must be an instance of Rectangle")
        return (rect_1, rect_2)[rect_1.area() < rect_2.area()]
