package test;

import java.util.Calendar;

import org.junit.Test;

public class MyTest {
	
	public static void main(String[] args) {
		// 测试多用户提交
		// 测试mh7649提交
		Calendar c = Calendar.getInstance();
		System.out.println(c.get(Calendar.WEEK_OF_YEAR));
	}
	
	@Test
	public void testAtest() {
		System.out.println(16);
	}
	
	@Test
	public void testTortoiseGitCommit() {
		System.out.println(21 + "test");
	}
	
}
