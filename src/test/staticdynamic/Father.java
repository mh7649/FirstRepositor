package test.staticdynamic;

public class Father {
	
	public Father() {
		System.out.println("Father" +"6");
	}
	
	public Father(int a) {
		System.out.println("Father" +a);
	}
	
	protected Father(String a) {
		System.out.println("Father" +a);
	}
	
	private Father(long a) {
		System.out.println("Father" +a);
	}
	
	void subFather() {
		System.out.println("Father" +new Father(1L));
	}
	
	static {
		System.out.println("Father" +"26");
	}
	
	{
		System.out.println("Father" +"30");
	}
}
