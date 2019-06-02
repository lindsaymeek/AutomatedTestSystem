
/* @(#)LimitedStyledDocument.java	1.0 02/28/04 Entry201

Title:							PSOC Contest Entry 201
Description:					Text Editor Document Class
Development Tools:				Sun JDK 1.3, Sun JavaCOMM API

*/


import javax.swing.*; 
import javax.swing.text.*; 
import java.awt.Toolkit;

public class LimitedStyledDocument extends DefaultStyledDocument {
    int maxCharacters;
	
    /**
     * Constructs a <code>LimitedStyledDocument</code>
     * with the specified maximum size.
     *
     * @param   maxChars  The maximum number of characters that the document can contain.
     */

    public LimitedStyledDocument(int maxChars) {
        maxCharacters = maxChars;
    }

    /**
     * Erases the contents of the document
     */

	public void clear()
	        throws BadLocationException {
		if(super.getLength() > 0)
			super.remove(0,super.getLength());
	}
	
 	/**
     * Inserts a text string into the document
	 * 
	 * @param offs	The character offset within the document
	 * @param str	The string to be inserted
	 * @param a		The font attributes associated with the string
     */
	
    public void insertString(int offs, String str, AttributeSet a) 
        throws BadLocationException {

        //This rejects the entire insertion if it would make
        //the contents too long. Another option would be
        //to truncate the inserted string so the contents
        //would be exactly maxCharacters in length.
        if ((getLength() + str.length()) <= maxCharacters)
            super.insertString(offs, str, a);
        else
            Toolkit.getDefaultToolkit().beep();
    }
}
