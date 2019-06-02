
/** @(#)ContestEntry201.java	1.0 02/28/04 Entry201

Title:							PSOC Contest Entry 201
Description:					Windows front-end interface for automated test system
Development Tools:				Sun JDK 1.3, Sun JavaCOMM API

*/

import java.awt.*;
import java.awt.event.*;
import java.util.Hashtable;
import java.io.*;
import javax.swing.*;
import javax.swing.text.*;
import javax.swing.event.*;
import javax.swing.undo.*;

public class ContestEntry201 extends JFrame {
    private JTextPane textPane;
    private LimitedStyledDocument lsd;
    JTextArea statusLog;
    private String newline = "\n";
    private static final int MAX_CHARACTERS = 10000;
    private Hashtable actions;
	JLabel statusLabel;
	private String file,comport;
	
    //undo helpers
    private UndoAction undoAction;
    private RedoAction redoAction;
	private SaveAction saveAction;
	private LoadAction loadAction;
	private RunAction  runAction;
	private CommAction com1Action,com2Action,com3Action,com4Action;
	
    private  UndoManager undo = new UndoManager();
	
   /**
     * Constructs a <code>ContestEntry201</code> GUI
     * using the nominated test script. 
     *
     * @param   file		The name of the test script file
     */	
    public ContestEntry201(String file) {
        //some initial setup
        super("PSOC Contest Entry 201. Automated Test System.");

		this.file=file;
		comport="COM1";
		
        //Create the document for the text area.
        lsd = new LimitedStyledDocument(MAX_CHARACTERS);

        //Create the text pane and configure it.
        textPane = new JTextPane(lsd);  //All right! No 60's jokes.
        textPane.setCaretPosition(0);
        textPane.setMargin(new Insets(5,5,5,5));
        JScrollPane scrollPane = new JScrollPane(textPane);
        scrollPane.setPreferredSize(new Dimension(400, 300));

        //Create the text area for the status log and configure it.
        statusLog = new JTextArea(5, 30);
        statusLog.setEditable(false);
        JScrollPane scrollPaneForLog = new JScrollPane(statusLog);

        //Create a split pane for the change log and the text area.
        JSplitPane splitPane = new JSplitPane(
                                       JSplitPane.VERTICAL_SPLIT,
                                       scrollPane, scrollPaneForLog);
        splitPane.setOneTouchExpandable(true);

        //Create the status area.
        JPanel statusPane = new JPanel(new GridLayout(1, 1));
        statusLabel =
                new JLabel("Idle");
        statusPane.add(statusLabel);

        //Add the components to the frame.
        JPanel contentPane = new JPanel(new BorderLayout());
        contentPane.add(splitPane, BorderLayout.CENTER);
        contentPane.add(statusPane, BorderLayout.SOUTH);
        setContentPane(contentPane);

        //Set up the menu bar.
        createActionTable(textPane);
		JMenu fileMenu = createFileMenu();
        JMenu editMenu = createEditMenu();
        JMenu toolsMenu = createToolsMenu();
        JMenu configMenu = createConfigMenu();
        JMenuBar mb = new JMenuBar();
		mb.add(fileMenu);
        mb.add(editMenu);
		mb.add(toolsMenu);
		mb.add(configMenu);
        setJMenuBar(mb);
		
        // Load the test file into memory
        loadDocument();

        //Start watching for undoable edits and caret changes.
        lsd.addUndoableEditListener(new MyUndoableEditListener());

    }

    /* Listen for edits that can be undone. */
    private class MyUndoableEditListener
                    implements UndoableEditListener {
        public void undoableEditHappened(UndoableEditEvent e) {
            //Remember the edit and update the menus.
            undo.addEdit(e.getEdit());
            undoAction.updateUndoState();
            redoAction.updateRedoState();
        }
    }

    /* Create the edit menu. */
    private JMenu createEditMenu() {
        JMenu menu = new JMenu("Edit");

        undoAction = new UndoAction();
        menu.add(undoAction);

        redoAction = new RedoAction();
        menu.add(redoAction);

        menu.addSeparator();

        //These actions come from the default editor kit.
        menu.add(getActionByName(DefaultEditorKit.cutAction));
        menu.add(getActionByName(DefaultEditorKit.copyAction));
        menu.add(getActionByName(DefaultEditorKit.pasteAction));

        menu.addSeparator();

        menu.add(getActionByName(DefaultEditorKit.selectAllAction));
        return menu;
    }

    //Create the file menu.
    private JMenu createFileMenu() {
        JMenu menu = new JMenu("File");
		
		loadAction = new LoadAction();
		menu.add(loadAction);

        menu.addSeparator();

		saveAction = new SaveAction();
		menu.add(saveAction);
		
		
        return menu;
    }

    //Create the tools menu.
    private JMenu createToolsMenu() {
        JMenu menu = new JMenu("Tools");
		
		runAction = new RunAction();
		menu.add(runAction);
		
        return menu;
    }

    //Create the config menu.
    private JMenu createConfigMenu() {
        JMenu menu = new JMenu("Config");
		
		com1Action = new CommAction("COM1");
		menu.add(com1Action);
		com2Action = new CommAction("COM2");
		menu.add(com2Action);
		com3Action = new CommAction("COM3");
		menu.add(com3Action);
		com4Action = new CommAction("COM4");
		menu.add(com4Action);
		
		highlight();
		
        return menu;
    }

	//
	// Highlight the active com port
	//
	private void highlight()
	{
		if(comport.equals("COM1"))
			com1Action.putValue(AbstractAction.NAME,"COM1*");
		else
			com1Action.putValue(AbstractAction.NAME,"COM1");
			
		if(comport.equals("COM2"))
			com2Action.putValue(AbstractAction.NAME,"COM2*");
		else
			com2Action.putValue(AbstractAction.NAME,"COM2");
			
		if(comport.equals("COM3"))
			com3Action.putValue(AbstractAction.NAME,"COM3*");
		else
			com3Action.putValue(AbstractAction.NAME,"COM3");
			
		if(comport.equals("COM4"))
			com4Action.putValue(AbstractAction.NAME,"COM4*");
		else
			com4Action.putValue(AbstractAction.NAME,"COM4");
			
	}
	
	//
	// Load the script into memory
	//
    private void loadDocument() {
		FileInputStream f;
		AttributeSet attr=new SimpleAttributeSet();
		StringBuffer str=new StringBuffer(128);
		int i,x;
		
		try {
			f = new FileInputStream(file);
			
 			try {
			// erase document
			lsd.clear();
            } catch(BadLocationException ble) {
				statusLabel.setText("Couldn't erase document");
				try { f.close(); } catch(IOException ioe) { }
				return;
			}
			
			x=0;
			while(x >= 0)
			{
			
			// erase string contents
			if(str.length() > 0)
				str.delete(0,str.length());
			
			// scan a line in to EOL
			for(i=0;i<128;i++)
			{
				try {
					x=f.read();
				} catch(IOException ioe) {
					statusLabel.setText("I/O error on read");
					break;
				}
				if(x < 0 || x == 10)
					break;
				if(x > 31)
					str.append((char)x);
					
			}
			
				try {
					lsd.insertString(lsd.getLength(),str.toString()+newline,attr);
				} catch(BadLocationException ble) {
					statusLabel.setText("Couldn't insert text '"+str.toString()+"'");
					break;
				}
			} // while
			try { f.close(); } catch(IOException ioe) { }
			if(x < 0)
				statusLabel.setText("Loaded "+file);
	
			
		} catch(FileNotFoundException fnfe) {
			statusLabel.setText("Couldn't load "+file);
			
		}         
    }

    //The following two methods allow us to find an
    //action provided by the editor kit by its name.
    private void createActionTable(JTextComponent textComponent) {
        actions = new Hashtable();
        Action[] actionsArray = textComponent.getActions();
        for (int i = 0; i < actionsArray.length; i++) {
            Action a = actionsArray[i];
            actions.put(a.getValue(Action.NAME), a);
        }
    }

    private Action getActionByName(String name) {
        return (Action)(actions.get(name));
    }

	
    class UndoAction extends AbstractAction {
        public UndoAction() {
            super("Undo");
            setEnabled(false);
        }
          
        public void actionPerformed(ActionEvent e) {
            try {
                undo.undo();
            } catch (CannotUndoException ex) {
                statusLabel.setText("Unable to undo: " + ex);
                ex.printStackTrace();
            }
            updateUndoState();
            redoAction.updateRedoState();
        }
          
        protected void updateUndoState() {
            if (undo.canUndo()) {
                setEnabled(true);
                putValue(Action.NAME, undo.getUndoPresentationName());
            } else {
                setEnabled(false);
                putValue(Action.NAME, "Undo");
            }
        }      
    }    

    class RedoAction extends AbstractAction {
        public RedoAction() {
            super("Redo");
            setEnabled(false);
        }

        public void actionPerformed(ActionEvent e) {
            try {
                undo.redo();
            } catch (CannotRedoException ex) {
                statusLabel.setText("Unable to redo: " + ex);
                ex.printStackTrace();
            }
            updateRedoState();
            undoAction.updateUndoState();
        }

        protected void updateRedoState() {
            if (undo.canRedo()) {
                setEnabled(true);
                putValue(Action.NAME, undo.getRedoPresentationName());
            } else {
                setEnabled(false);
                putValue(Action.NAME, "Redo");
            }
        }
    }    

	//
	// Save script to disk
	//
	private void saveDocument()
	{
		int i;
			FileOutputStream f;
			String str ;
		
		  try {
		   str = lsd.getText(0,lsd.getLength());
		  } catch(BadLocationException ble) {
		  	statusLabel.setText("Unable to access document");
			return;
		  }
		  
		  try {
		  	f = new FileOutputStream(file);
		  } catch(IOException ioe) {
		  	statusLabel.setText("Unable to open "+file+" for write");
			return;
		  }
	
		  
		   for(i=0;i<str.length();i++)
		   {
		  	try {
		  	f.write(str.charAt(i));
			} catch(IOException ioe) {
				statusLabel.setText("Unable to write "+file);
				break;
			}
		   }	  
		  
		  try {
		  	f.close();
			statusLabel.setText("Saved "+file);
						
			} catch(IOException ioe) {
				statusLabel.setText("Unable to close "+file);
			}
			

		 }
		 
			//
			// Handler for save menu item
			//
			class SaveAction extends AbstractAction {
			
				public SaveAction() {
		            super("Save");
		            setEnabled(true);
		        }
		
		        public void actionPerformed(ActionEvent e) {
		
					saveDocument();
					
		        }
		
		    }
 
	//
	// Handler for load menu item
	//
	class LoadAction extends AbstractAction {
	
		public LoadAction() {
            super("Load");
            setEnabled(true);
        }

        public void actionPerformed(ActionEvent e) {

			loadDocument();
			
        }

    }
	
	//
	// Handler for comm port menu item
	//
	class CommAction extends AbstractAction {
	
		public CommAction(String port) {
            super(port);
            setEnabled(true);
        }

        public void actionPerformed(ActionEvent e) {
			comport=e.getActionCommand();
			statusLabel.setText("Comport "+comport);
			highlight();
        }

    }


    /**
	 * 	The standard main method.
	 *	
	 *	@param	args	Arguments [script name]
	**/
    public static void main(String[] args) {
		String name;
		if(args.length < 1)
			name="ate.scr";
		else
			name=args[0];
        final ContestEntry201 frame = new ContestEntry201(name);
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
            public void windowActivated(WindowEvent e) {
                frame.textPane.requestFocus();
            }
        });

        frame.pack();
        frame.setVisible(true);
    }
	
	//
	// Handler for run menu item
	//
	class RunAction extends AbstractAction {
		
		
		public RunAction() {
            super("Run");

            setEnabled(true);
        	}

        public void actionPerformed(ActionEvent e) {
        
			try {
					AutomatedTestEngine ate = new AutomatedTestEngine(lsd,statusLabel,statusLog,comport);
					
					if(false==ate.run())
						statusLabel.setText("Tests incomplete");
					else
						statusLabel.setText("Tests complete");
						
					
			} catch(Exception exc) {
					statusLog.append(exc.getMessage()+newline);
			}
			
		
        }
    }
		
}
