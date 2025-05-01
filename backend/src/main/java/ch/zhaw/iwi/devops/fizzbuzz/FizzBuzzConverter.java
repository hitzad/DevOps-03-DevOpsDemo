package ch.zhaw.iwi.devops.fizzbuzz;

public class FizzBuzzConverter {

    public String convert(int i) {
        StringBuilder result = new StringBuilder();

        if (i % 3 == 0) {
            result.append("Fizz");
        }
        if (i % 5 == 0) {
            result.append("Buzz");
        }
        if (i % 7 == 0) {
            result.append("DevOps");
        }

        return result.length() > 0 ? result.toString() : String.valueOf(i);
    }
}

