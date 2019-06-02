
/* @(#)TestBusException.java	1.0 02/28/04 Entry201

Title:							PSOC Contest Entry 201
Description:					Exception for Serial Interface to Test Pods
Development Tools:				Sun JDK 1.3, Sun JavaCOMM API

*/

public class TestBusException extends Exception {

    /**
     * Constructs a <code>TestBusException</code>
     * with the specified detail message.
     *
     * @param   str   the detail message.
     */
    public TestBusException(String str) {
        super(str);
    }

    /**
     * Constructs a <code>TestBusException</code>
     * with no detail message.
     */
    public TestBusException() {
        super();
    }
}
