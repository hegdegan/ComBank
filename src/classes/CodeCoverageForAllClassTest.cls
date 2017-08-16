@isTest 
public class CodeCoverageForAllClassTest
{
    static testMethod void testMethod1() 
    {
       
        Test.startTest();
            CodeCoverForAllClasses.method1();
            CodeCoverForAllClasses.method2();
            CodeCoverForAllClasses.method3();
            CodeCoverForAllClasses.method4();
            CodeCoverForAllClasses.method5(); 
        Test.stopTest();
    }
}