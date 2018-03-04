package test.staticdynamic;

public class Son extends Father {

	static {
		System.out.println("Son" +"6");
	}
	
	{
		System.out.println("Son" +"10");
	}
	
	public Son() {
		System.out.println("Son" +"14");
	}
	
	public Son(long a) {
		System.out.println("Son" +a);
	}
	
	public static void main(String[] args) {
		System.out.println("Son" +new Son(999L));
	}
}
