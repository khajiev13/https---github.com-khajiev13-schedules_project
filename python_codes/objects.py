class Student:
    def __init__(self, name, house) -> None:
        if not name:
            raise ValueError("Missing name")
        if house not in ["Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin"]:
            raise ValueError("Invalid house")
        self.name = name
        self.house = house

    def __str__(self) -> str:
        return f"{self.name} from {self.house}"


def main():
    name = get_name()
    house = get_house()
    student = Student(name, house)
    print(student)


def get_name():
    return input("Name: ")


def get_house():
    return input("House: ")


if __name__ == "__main__":
    main()
