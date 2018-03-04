package test;

import java.util.Calendar;

import org.junit.Test;

public class MyTest {
	
	public static void main(String[] args) {
		Calendar c = Calendar.getInstance();
		System.out.println(c.get(Calendar.WEEK_OF_YEAR));
	}
	
	@Test
	public void testAtest() {
		System.out.println(16);
	}
	
}
