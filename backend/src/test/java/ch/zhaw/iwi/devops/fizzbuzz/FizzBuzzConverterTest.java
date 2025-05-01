package ch.zhaw.iwi.devops.fizzbuzz;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class FizzBuzzConverterTest {

    FizzBuzzConverter fizzBuzz = new FizzBuzzConverter();

    @Test
    public void fizzBuzzConverter1() {
        Assertions.assertEquals("1", fizzBuzz.convert(1));
    }

    @Test
    public void fizzBuzzConvertor2() {
        Assertions.assertEquals("2", fizzBuzz.convert(2));
    }

    @Test
    public void fizzBuzzConvertor3() {
        Assertions.assertEquals("Fizz", fizzBuzz.convert(3));
    }

    @Test
    public void fizzBuzzConvertorMultiplesOfThree() {
        Assertions.assertEquals("Fizz", fizzBuzz.convert(6));
    }

    @Test
    public void fizzBuzzConvertorMultiplesOfFive() {
        Assertions.assertEquals("Buzz", fizzBuzz.convert(5));
    }

    @Test
    public void fizzBuzzConvertorMultiplesOfSeven() {
        Assertions.assertEquals("DevOps", fizzBuzz.convert(7));
    }

    @Test
    public void fizzBuzzConvertorThreeAndFive() {
        Assertions.assertEquals("FizzBuzz", fizzBuzz.convert(15));
    }

    @Test
    public void fizzBuzzConvertorThreeAndSeven() {
        Assertions.assertEquals("FizzDevOps", fizzBuzz.convert(21));
    }

    @Test
    public void fizzBuzzConvertorFiveAndSeven() {
        Assertions.assertEquals("BuzzDevOps", fizzBuzz.convert(35));
    }

    @Test
    public void fizzBuzzConvertorThreeFiveSeven() {
        Assertions.assertEquals("FizzBuzzDevOps", fizzBuzz.convert(105));
    }
} 
