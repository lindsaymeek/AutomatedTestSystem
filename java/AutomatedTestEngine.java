
/** @(#)AutomatedTestEngine.java	1.0 02/28/04 Entry201

Title:							PSOC Contest Entry 201
Description:					Automated test interpreter and runtime engine
Development Tools:				Sun JDK 1.3, Sun JavaCOMM API

*/

import javax.swing.*;
import javax.swing.text.*;

public class AutomatedTestEngine  extends Object {

	private LimitedStyledDocument lsd;
	private JLabel statusLabel;
	private JTextArea statusLog;
	private String newline = "\n";
	private boolean abort;
	private int rate;
	private int line;
	private int trace;

	private int order_index;
	private int orderp[];
	private int ordern[];
	
	private int element;
	private int clock=0;
	private boolean used_clock;
	private int cycle=0;
	private int no_tests;
	private int test_portp[],test_portn[],test_type[],test_state[],test_upper[],test_lower[],test_gaink[];

	final int RPT_HEAPSIZE=100;
	final int VAR_HEAPSIZE=500;
	final int MAX_VECTOR=24;
	
	String rpt_heap[];
	String var_heap[];
	int var_value[];
	int rpt_idx,rpt_cnt,var_idx;
	TestBus bus;
	boolean open;
	
	/**
	**	Constructs an <code>AutomatedTestEngine</code> object
	**
	**  @param lsd			The document containing the script
	**  @param statusLabel	The label at the bottom of the window used for status information
	**  @param statusLog 	The text window for displaying test results and diagnostics
	**  @param comport		The name of the comport that the test ports are connected to
	**  @exception If the comport could not be opened/configured
	*/
	public AutomatedTestEngine(LimitedStyledDocument lsd,
								JLabel statusLabel,
								JTextArea statusLog,
								String comport)
			throws TestBusException
	{
			int i;
			
			open=false;		
			this.statusLabel = statusLabel;
			this.statusLog = statusLog;
			this.lsd = lsd;
		
			rate=100;

			trace=2;
			rpt_cnt=0;
			rpt_heap = new String[RPT_HEAPSIZE];
			var_heap = new String[VAR_HEAPSIZE];
			var_value = new int[VAR_HEAPSIZE];
			var_idx=0;
			cycle=0;
			orderp = new int[MAX_VECTOR];
			ordern = new int[MAX_VECTOR];
			// free array
			for(i=0;i<VAR_HEAPSIZE;i++)
				var_value[i]=-1;
		
			test_portp = new int[MAX_VECTOR];
			test_portn = new int[MAX_VECTOR];			
			test_type = new int[MAX_VECTOR];
			test_state = new int[MAX_VECTOR];
			test_upper = new int[MAX_VECTOR];
			test_lower = new int[MAX_VECTOR];
			test_gaink = new int[MAX_VECTOR];
			
			bus = new TestBus(comport);
			
			open=true;
	}

	//	Set the trace level 0..3
	private void set_trace(int n)
		throws NumberFormatException
	{
		if(trace < 0 || trace > 3)
			throw new NumberFormatException("Trace level must be between 0 and 3");
		
			
		trace=n;
	}

    // start a new test vector specification
	private void init_order()
	{
		order_index=0;
	}

	//
	// process a test digital input request [queued for later processing]
	//
	private void test_digital_input(int portp,int portn,int state)
	{
   		test_portp[no_tests]=portp;
   		test_portn[no_tests]=portn;
   		test_type[no_tests]=0;
   		test_state[no_tests]=state;
		
   		no_tests++;
	}

	//
	// process a test analog input request [queued for later processing]
	//
	private void test_analog_input(int portp, int portn, double fvalue_lower, double fvalue_upper, double gain)
	{
		// allowable gains
		final double gains[]={16.0,8.0,5.333,4.0,3.2,2.667,2.286,2.0,1.778,1.6,1.455,1.333,1.231,1.143,1.067,1.0,
      									0.0625,0.125,0.1875,0.25,0.3125,0.375,0.4375,0.5,0.5625,0.625,0.6875,0.75,0.8125,0.875,0.9375,1.0};

      double diff,d;
     	int lower,upper,gaink,i,idx;

	  //
	  // only supports ADC routing on port 0
	  //
	  if(portp >= 0 && ((portp>>3)&3)>0)
	  	err(10,value2name(portp));
      else if(portn >= 0 && ((portn>>3)&3)>0)
	  	err(10,value2name(portn));
	  else
      {
	  	// are we just reading the input pin or conducting a test
	  	if(fvalue_lower >= 0 && fvalue_upper >= 0)
		{
	    	// test.. is it a double-ended input? (using the instrumentation amp)
			if(portp >= 0 && portn >= 0)
			{
				// yes, need to compensate for a x2 gain
				fvalue_lower *= 2.0;
				fvalue_upper *= 2.0;
			
				if(trace > 2)
					echo(" GAIN*2 ");
			}


	    // has gain been specified?
      	if(gain >=0.0)
         {
      	 // yes, find the closest supported gain to the requested gain
      	 idx=-1;
          diff=32.0;
          for(i=0;i<32;i++)
          {
         	d=Math.abs(gains[i]-gain);
            if(d<diff)
            {
            	diff=d;
               idx=i;
            }
          }
         }
         else
         {
		  //
          // gain not specified.. pick gain the gives the lowest quantisation error
		  // with both limits in range
		  // 
          idx=-1;
          diff=0.0;
		  gain=1.0;
          for(i=0;i<32;i++)
          {
         		lower=(int)(2047.0*fvalue_lower*gains[i]);
         		upper=(int)(2047.0*fvalue_upper*gains[i]);


               if(Math.abs(upper) > 2047 || Math.abs(lower) > 2047 )
               	continue;

               d=upper-lower;

               if(d >= diff)
               {
               	diff = d;
                  idx=i;
               }
			}
			
         }

		 // map to hardware constant
         gaink=(idx & 15) << 4;
         if((idx & 16)==0)
         	gaink|=8;
			
		 //
		 // quantise thresholds to 12-bit levels
		 //
		 fvalue_lower *= gains[idx]/gain;
		 fvalue_upper *= gains[idx]/gain;
         lower=(int)(2047.0*fvalue_lower);
         upper=(int)(2047.0*fvalue_upper);
		
		//
		// queue test until after outputs have been driven
		//
   		test_portp[no_tests]=portp;
   		test_portn[no_tests]=portn;
      	test_type[no_tests]=1;
      	test_lower[no_tests]=lower;
      	test_upper[no_tests]=upper;
      	test_gaink[no_tests]=gaink;
	
      	no_tests++;

		if(trace > 2)
			echo("TEST ANALOG GAIN="+gains[idx]+"/"+gaink+" "+fvalue_lower+"/"+lower+"-"+fvalue_upper+"/"+upper+" PORT "+value2name(portp,portn)+newline);

		}
		else
		{
	    	// no, is it a double-ended input? (using the instrumentation amp)
			if(portp >= 0 && portn >= 0)
				// yes, need to compensate for a x2 gain
				gain=0.5;
			else
				gain=1.0;
				
      	 	// map gain to a constant
          	for(idx=0;idx<32;idx++)
          	{
         		if(gains[idx]==gain)
					break;
         	}

			// map to hardware constant
	        gaink=(idx & 15) << 4;
         	if((idx & 16)==0)
         		gaink|=8;

			//
			// queue read until after outputs have been driven
			//
   			test_portp[no_tests]=portp;
   			test_portn[no_tests]=portn;
      		test_type[no_tests]=2;
      		test_gaink[no_tests]=gaink;

			no_tests++;

			if(trace > 2)
				echo("READ ANALOG GAIN="+gains[idx]+"/"+gaink+" PORT "+value2name(portp,portn)+newline);
			
      		}
		}
	

	}

	//
	// start a new test vector
	//
 	private void start_vector()
	{
		element=0;
   		used_clock=false;
   		no_tests=0;

   		cycle++;
	}
	
	//
	// test a port for high impedance
	//
	private boolean test_high_impedance(int port)
		throws TestBusException
	{
		boolean ok;
		
		ok=true;
		
		// drive pin resistive pulldown, low (pull down using 5.6K resistor)
		bus.drive_digital_output(port, 0, 0);
		// wait for pin to settle
		rate_delay();
		if(0!=bus.read_digital_input(port,false))
			ok=false;
		// drive pin resistive pullup, high (pull up using 5.6K resistor)
		bus.drive_digital_output(port, 1, 3);
		// wait for pin to settle
		rate_delay();
		if(1!=bus.read_digital_input(port,false))
			ok=false;
		// reset pin to high impedance
		bus.drive_digital_output(port, 0, 2);
		
		return ok;
	}
	
	//
	// terminate test vector and execute any queued tests
	//
	private void end_vector()
	{
		int i,p,n,v;
		boolean ok;

		if(element > 0)
		{
			if(trace > 2)
   				echo(newline+"VECTOR END"+newline);
			else if(trace > 1)
				echo(newline);
		
			// implement settle delay here
			rate_delay();
			
      		// run tests
		
      		for(i=0;i<no_tests;i++)
      		{
      		switch(test_type[i]) {
         	case 0:
			
				if(trace >= 1)
					echo(value2name(test_portp[i],test_portn[i])+"=");		
				
				//
				// processing for logic high, logic low, read state
				//
				if(test_state[i] < 2)
				{
				try { 
				 p=n=0;
				 if(test_portp[i] >= 0)
				 {
				 	p=bus.read_digital_input(test_portp[i],true);
					if(trace >= 1 || test_state[i] < 0)
						echo(""+p);
				 }
				 if(test_portn[i] >= 0)
				 {
				 	n=bus.read_digital_input(test_portn[i],true);
					
					if(trace >= 1 || test_state[i] < 0)
						echo(""+n);
				 }
				 
				 if(trace >= 1 || test_state[i] < 0)
				 	echo(" ");
					
				 if(test_state[i] >= 0)
				 {
				 	ok=true;
				 	if(test_portp[i] >= 0 && p!=test_state[i])
						ok=false;
					if(test_portn[i] >= 0 && n!=(test_state[i]^1))
						ok=false;
					if(!ok)
					{
						if(trace < 1)
							echo("FAIL:"+value2name(test_portp[i],test_portn[i]));
						else 
							echo("(FAIL)");
							
						echo(" ");
						abort=true;
					}
				 }

				 } catch(TestBusException tbe) {
					echo("TestBus failed on read_digital_input "+tbe.getMessage()+"\n");
					abort=true;
					i=no_tests;
				 }
				}
				else // processing for high impedance test
				{
					if(trace >= 1)
						echo("HiZ ");
						
					try {
							if(test_portp[i] >= 0)
							{
								if(false==test_high_impedance(test_portp[i]))
									abort=true;
							}
							if(test_portn[i] >= 0 && !abort)
							{
								if(false==test_high_impedance(test_portn[i]))
									abort=true;
							}
							if(abort && trace >= 1)
								echo("(FAIL) ");
							
						} catch(TestBusException tbe) {
							echo("TestBus failed on test_high_impedance "+tbe.getMessage()+"\n");
							abort=true;
							i=no_tests;
						}
					
						
				}
				
            	break;
            case 1:
			case 2:
				 if(trace >= 1 || test_type[i]==2)
				 	echo(value2name(test_portp[i],test_portn[i])+"=");
			
				try {
            	 v=bus.read_analog_input(test_portp[i],test_portn[i],test_gaink[i]);
				
				 if(trace >= 1 || test_type[i]==2)
				 	echo(new Double(v/2048.0).toString()+" ");
									
				 if(test_type[i]==1)
				 {
				  if(v < test_lower[i] || v > test_upper[i])
				  {
				 	if(trace >= 1)
						echo("(FAIL)");
					else
						echo("FAIL:"+value2name(test_portp[i],test_portn[i]));
					echo(" ");
					abort=true;
				  }
				 }
				} catch(TestBusException tbe) {
						echo("TestBus failure on read_analog_input "+tbe.getMessage()+"\n");
						abort=true;
						i=no_tests;
				}
				
            	break;

         		}

      		}

      		if(used_clock)
      			clock ^= 1;
   		}
	}
	
	//
	// set the test execution rate in milliseconds
	//
	private void set_rate(int n)
		throws NumberFormatException
	{
		if(rate < 1)
			throw new NumberFormatException("Rate must be greater than 1");

		rate=n;
	}

	// delay the current thread by rate ms
	private void rate_delay()
	{
 		try
            { // Snoozing a bit.
                Thread.sleep(rate);
            }
            catch (Exception e)
            {
                statusLabel.setText("Couldn't sleep! "+e.getMessage());
            }
	}

	// return ascii representation of single-ended port name
	private String value2name(int value)
	{
		if(value >= 0)
			return ""+(char)('P'+((value>>5)&7))+(char)(((value >> 3)&3)+'0')+(char)((value & 7)+'0');	
		else
			return "AGND";
	}

	// return ascii representation of double-ended port name
	private String value2name(int valuep,int valuen)
	{
		if(valuep >= 0)
		{
			if(valuen >= 0)
				return value2name(valuep)+"-"+value2name(valuen);
			else
				return value2name(valuep);
		}
		else
			return value2name(valuen);
	}
	
	// insert a test vector element definition
	private void add_order(int valuep,int valuen)
	{
		int i;

		// scan for duplicates
   		for(i=0;i<order_index;i++)
   		{
			if(valuep >= 0)
			{
				if(orderp[i]==valuep || ordern[i]==valuep)
				{
						err(5,value2name(valuep));
         				break;
				}
      		}
			if(valuen >= 0)
			{
				if(orderp[i]==valuen || ordern[i]==valuen)
				{
						err(5,value2name(valuen));
         				break;
				}
      		}
   		}

   		if(order_index >= MAX_VECTOR)
   			err(6,value2name(valuep,valuen));
   		else
		{
   			orderp[order_index]=valuep;
			ordern[order_index++]=valuen;
		}
	}

	//
	// evaluate test vector element
	//
	private void eval_vector_element(String p)
	{
		int portp,portn,mode;
   		int s,s2,s3,len;
   		double val1,val2,gain;

		if(element == 0)
   		{
			if(trace > 2)
   				echo("VECTOR START"+newline);
   		}

		try { 
		
   		if(element >= order_index)
   			err(6,p);
   		else
   		{
    		portp=orderp[element];
			portn=ordern[element];
			
			if(trace > 2)
    			echo("["+value2name(portp,portn)+"]="+p+" ");
			else if(trace > 1)
				echo(p+" ");
			
			len=p.length();
			
			//
			// extract resitive pullup / pulldown modifiers
			//
			mode=1;		// CMOS by default
			
			if(len == 2)
			{
				switch(Character.toLowerCase(p.charAt(1))) {
					case 'u':
						len--;
						mode=3;
						break;
					case 'd':
						len--;
						mode=0;
						break;
				}
				
			}
			
			//
    		// parse test vector elemental operation
			//
    		if(len==1)
    		{
				
				
    			switch(Character.toLowerCase(p.charAt(0))) {
      			default:
         			err(4,p);
            		break;
         		case '0':
         		case '1':
         			bus.drive_digital_output(portp, portn, p.charAt(0)-'0', mode);
            		break;
         		case 'c':
         			bus.drive_digital_output(portp,portn,clock,mode);
            		used_clock=true;
            		break;
         		case 'k':
         			bus.drive_digital_output(portp,portn,clock ^ 1,mode);
            		used_clock=true;
            		break;
         		case 'r':
         			bus.drive_digital_output(portp,portn, Math.random() > 0.5 ? 1:0,mode );
            		break;
         		case 'x':
         			bus.drive_digital_output(portp,portn,0,2);
            		break;
				case 'l':
         			test_digital_input(portp,portn, 0);
            		break;
         		case 'h':
         			test_digital_input(portp,portn, 1);
            		break;
				case 'z':
					test_digital_input(portp,portn, 2);
					break;
         		case '*':
					if(portp < 0 || ((portp>>3)&3)==0)
					{
						if(portn < 0 || ((portn>>3)&3)==0)
	         				test_analog_input(portp,portn,-1,-1,-1);
						else
							test_digital_input(portp,portn,-1);
					}
					else
						test_digital_input(portp,portn,-1);
            		break;
      			} // switch
    		} // strlen
    		else // is an analog element
    		{
   				s=0;
        	 	// scan for test, or driven value
        		while(s < p.length())
         		{
         			if(p.charAt(s)=='-' || p.charAt(s)==',')
            			break;
            		s++;
         		}

         		if(s >= p.length())
         		{
         			// driven value
					try {
						val1 = Double.parseDouble(p);
						
            			if(val1 < 0.0)
            	   			val1=0.0;
               			if(val1 > 1.0)
            	   			val1=1.0;
							
						if(trace > 2)
						    echo("DRIVE ANALOG "+val1+" on PORT "+value2name(portp,portn)+" ");

            			bus.drive_analog_output(portp,portn, val1);
						
					} catch(NumberFormatException nfe) {
            			err(4,p);
					}
         		}
         		else // - or , encountered
         		{
         			gain=-1.0;
					s3=0;
					
         			// extract gain parameter if found
         			if(p.charAt(s)==',')
            		{
                  		s2=s+1;
                  		while(s2 < p.length())
                  		{
                  			if(p.charAt(s2)=='-')
                    	 		break;
                    	 s2++;
                  		}
                  		if(p.charAt(s2)!='-')
                  			err(4,p);
                  		else
                  		{
							try {
								gain=Double.parseDouble(p.substring(0,s-1));
				
    			              	s3=s+1;
    			                s=s2;
    						} catch(NumberFormatException nfe) {
							   	err(4,p.substring(0,s-1));
							}
                  		}
            		}
            		else
					{
						// leading negative
						if(s==0)
						{
							s++;
							
                  			while(s < p.length())
                  			{
                  				if(p.charAt(s)=='-')
                    	 			break;
                    	 		s++;
                  			}
                  			if(p.charAt(s)!='-')
                  				err(4,p);
							
						}
					}
					
					try {
						val1=Double.parseDouble(p.substring(s3,s));
            	
            			if(val1 < -1.0) val1=-1.0;
               			if(val1 > 1.0) val1=1.0;

            			val2=Double.parseDouble(p.substring(s+1));
						
 						if(val2 < -1.0) val2=-1.0;
               			if(val2 > 1.0) val2=1.0;
               			test_analog_input(portp,portn,val1,val2,gain);
						} catch(NumberFormatException nfe) {
							err(4,p);	
					}
               
         		}
        } // strlen(p) == 1

	 	element++;

   		} // element < order_index
		
		} catch(TestBusException tbe) {
			statusLog.append("TestBus Error "+tbe.getMessage()+"\n");
			abort=true;
		}
	}

	//
	// string printer
	//
	private void echo(String str)
	{
		statusLog.append(str);
	}


	//
	// error reporter
	//
	private void err(int no,String arg)
	{
		final String errs[] = { "Invalid Command", 						// 0
   								"Internal",        						// 1
    	                        "Unknown Variable",                 	// 2
    	                        "Out of Variable Heap Space",       	// 3
    	                        "Syntax Error",                     	// 4
    	                        "Duplicated Test Vector Element",   	// 5
    	                        "Too Many Test Vector Elements",    	// 6
    	                        "Out of Repeat Heap Space",         	// 7
    	                        "Too Many Nested Repeats",          	// 8
    	                        "Analog Output Not Supported",      	// 9
    	                        "Analog Input Not Supported"};    		// 10
    	                        
		
   		echo("ERROR "+no+" "+errs[no]);
   		
   		if(arg != "")
   		 	echo(" "+arg);

		echo(newline);
   		abort=true;
	}

	//
	// scan for reserved names p00..07, p10..17, p20..27, q,r,s,t,u,v
	//
	// returns -1 if not reserved, otherwise index number 0..31
	//
	private int is_reserved(String name)
	{
		int port,bit,pod;

	   if(name.length()==3)
	   {
	   		pod = Character.toLowerCase(name.charAt(0)) - 'p';
		
    		if(pod >= 0 && pod < 8)
    		{
    			port = name.charAt(1)-'0';
		      	if(port >= 0 && port < 4)
				{
      				
      				bit = name.charAt(2)-'0';
      				if(bit >= 0 && bit < 8)
					{
      				
      					return (pod << 5)+(port<<3)+bit;
					}
				}
    		}
   		}
   		return -1;
	}

	//
	// scan for a variable, return value or -1 if not found
	//
	private int is_var(String name)
	{
		int i;

		for(i=0;i<var_idx;i++)
		{
			if(var_value[i] >= 0)
			{
			 if(var_heap[i].equalsIgnoreCase(name))
				return var_value[i];
			}
		}
		
		return -1;
	}

	//
	// add a variable to the heap, replacing duplicates
	//
	private void add_var(String name, int value)
	{
		int i;

		if(trace > 2)
			echo("ADD_VAR "+name+" = "+value2name(value)+newline);
		
   		// remove duplicates
		for(i=0;i<var_idx;i++)
		{
			if(var_value[i] >= 0)
			{
				if(var_heap[i].equalsIgnoreCase(name))
				{
					var_value[i]=value;
					return;
				}
			}
		}
		
		if(var_idx < VAR_HEAPSIZE)
		{
		 var_heap[var_idx] = new String(name);
		 var_value[var_idx++] = value;
		}
		else
			err(3, name);

	}
	
	//
	// map variable/port name to port value
	//
	// return -1 if not found
	//
	private int resolve_var(String name)
	{
		int x=is_reserved(name);

   		if(x >= 0)
   			return x;

   		x=is_var(name);

   		if(x >= 0)
   			return x;

   		err(2,name);

   		return -1;
	}

	//
	// evaluate a variable=value assignment
	//
	private void eval_var(String expr)
	{
		int p;
   		int value;

   		p=0;
   		while(p < expr.length())
   		{
   			if(expr.charAt(p)=='=')
      			break;
      		p++;
   		}
   		if(p >= expr.length())
   			err(4,expr);
   		else
   		{
      		value=resolve_var(expr.substring(p+1));
      		if(value >= 0)
      		{
  
      			add_var(expr.substring(0,p), value);
      		}
   		}
	}

	//
	// process an incoming line with respect to repeat block
	//
	private void process_repeat(String line, int rpt_req)
	{
		if(rpt_req != 0)
   		{

	 		if(rpt_cnt != 0)
   				err(8, "");

	 		rpt_idx = 0;
    		rpt_cnt = rpt_req;
   		}
   		else
   		{
	 		// line capture active?
	 		if(rpt_cnt != 0)
    		{
				if(rpt_idx  >= RPT_HEAPSIZE)
      				err(7,line);
      			else
      			{
					rpt_heap[rpt_idx++] = new String(line);
      			}
    		}
   		}
	}

	//
	// execute a repeat block
	//
	private void end_repeat()	
	{
		int idx,cnt=rpt_cnt;

   		rpt_cnt=0;	// cancel repeat line capture

   		while(--cnt > 0)
   		{
   			idx=0;

      		while(idx < rpt_idx)
      		{
      			process(rpt_heap[idx++]);

      		}

   		}
	}

	
	//
	// command parser
	//
	private void process(String line)
	{
   int p,pe;
   int i,j,state=0;    			// parser state
   // directives
   final String cmds[] = 
   		{ "exit", "msg", "order", "var", "rate", "repeat", 
		  "endr", "timeout", "trace", "samples", "freq",  
		"-" };
   boolean msg_flag=false;
   int rpt_req=0;
   boolean eol;
  
   p=0;

   start_vector();

   // strip leading spaces and comments
  	while(p < line.length())
   {
   	if(line.charAt(p)==';')
      	return;
      if(line.charAt(p)!=' ')
      	break;
      p++;
   }
   if(p >= line.length())
   	return;

	if(trace > 2)
		echo("--> "+line.substring(p)+" <--"+newline);
		
   // process to eol or space
   eol=false;
   do
   {
    pe=p;
    while(pe < line.length())
    {
   	if(line.charAt(pe)==' ' || line.charAt(pe)==';')
      	break;
      pe++;
    }

    if(p != pe)
    {
    	if(pe >= line.length())
      		eol=true;


     // process sub arguments

	
	//	echo("["+line.substring(p,pe)+"]"+newline);
		
	
     switch(state) {
     	case 0:		// top level scan
      	if(line.charAt(p)=='$') // command
         {
         	i=0;
         	while(!cmds[i].equalsIgnoreCase("-"))
            {
            	if(cmds[i].equalsIgnoreCase(line.substring(p+1,pe)))
               {
                switch(i) {
                	case 0: // exit
                  	abort=true;
                  	break;
                  case 1: // msg
                  	msg_flag=true;
                     state=1;
                     break;
                  case 2: // order
                  	init_order();
                     state=2;
                     break;
                  case 6: // endr
                  	end_repeat();
                     return;
                   case 3: // var
                   case 4: // rate
                   case 5: // repeat
                   case 7: // timeout
                   case 8: // trace
				   case 9: // samples
				   case 10: // freq
                     state=i;
                     break;
                  default:
                  	err(1,line.substring(p));
                     break;
                }
                break;
               }
               i++;
            }
            if(cmds[i].equalsIgnoreCase("-"))
            	err(0,line.substring(p,pe));
         }
         else // test vector
         {
         	eval_vector_element(line.substring(p,pe));
         }
         break;
      case 1:	// msg
      	 echo(line.substring(p,pe)+" ");
         break;
      case 2: // order
	  	j=line.substring(p,pe).indexOf('-');	// scan for a double-ended pair or inverted single-ended
		if(j >= 0)
		{
			if(j==0)
			{
				// single-ended inverted specification
				i=resolve_var(line.substring(p+1,pe));
				if(i >= 0)
					add_order(-1,i);
			}
			else
			{
				i=resolve_var(line.substring(p,p+j));
				j=resolve_var(line.substring(p+j+1,pe));
				if(i >= 0 && j >= 0)	
					add_order(i,j);
			}
		}
		else
		{
		 // single ended order specification
      	 i=resolve_var(line.substring(p,pe));
         if(i >= 0)
      		add_order(i,-1);
		}
      	break;
      case 3: // var
      	eval_var(line.substring(p,pe));
      	break;
      case 4: // rate
         set_rate(Integer.parseInt(line.substring(p,pe)));
         state=0;
         break;
      case 5: // repeat
       	i=Integer.parseInt(line.substring(p,pe));
         if(i>=0)
         	rpt_req=i;
         state=0;
     		break;
      case 7: // timeout
      	i=Integer.parseInt(line.substring(p,pe));
         if(i>=0)
         	bus.set_timeout(i);
         state=0;
         break;
      case 8: // trace
         set_trace(Integer.parseInt(line.substring(p,pe)));
         state=0;
         break;
      case 9: // samples
          	bus.set_samples(Integer.parseInt(line.substring(p,pe)));
         state=0;
         break;
      case 10: // freq
      	
         	bus.set_freq(Integer.parseInt(line.substring(p,pe)));
         state=0;
         break;
     	default:
       err(4,line.substring(p));
       break;
     }


     if(!eol)
     	p=pe+1;
     else
     	p=pe;

    }
   } while(pe != p);

   if(msg_flag)
   	echo(newline);

   end_vector();
   
	if(!abort)
   		process_repeat(line, rpt_req);
	

	}
	
	
	/**
	** Execute the test script
	** @return boolean indicating whether the test script was run to completion
	*/
	public boolean run()
	{
		int i,j;
		
		j=0;
		line=1;
		
		echo(newline);
		
		try {
		 for(i=0;i<lsd.getLength();i++)
	  	 {
			if(lsd.getText(i,1).equals(newline))
			{
				if(j != i)
				{
				 process(lsd.getText(j,i-j));
				 if(abort)
				 {
				 	// position the cursor at the start of the line
					
				 	break;
				 }
				}
				
				line++;
				j=i+1;
			}
		 }
		} catch(BadLocationException ble) {
			statusLabel.setText("Unable to access document at line "+line);
		}
		
		// perform cleanup operations
		if(open==true)
			bus.clean();
			
		open=false;
		
		return !abort;
	}
	
}
