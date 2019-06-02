
/* @(#)TestBus.java	1.0 02/28/04 Entry201

Title:							PSOC Contest Entry 201
Description:					Automated test system serial bus interface object
Development Tools:				Sun JDK 1.3, Sun JavaCOMM API

*/

import javax.comm.*;    			// communcation's api plug-in from sun
import java.io.*;
import javax.swing.*;

public class TestBus extends Object {
  
  	private OutputStream streamo;
  	private InputStream streami;
	private SerialPort sPort;
	private int timeout,samples,freq,dividek;
  	private CommPortIdentifier portId;	
	private boolean open;
	private byte buffer[];
	private String endcmd = ""+(char)10+(char)13;
	final String hex="0123456789ABCDEF";
		
    /**
     * Constructs a <code>TestBus</code> interface
     * on the nominated serial port
     *
     * @param   portname	The serial port name eg. COM1
	 * @exception TestBusException if the port could not be opened/configured
     */	
	public TestBus(String portname)
		throws TestBusException
	{
		set_timeout(1000);
		set_samples(1);
		set_freq(57);
		open=false;
		buffer = new byte[16];
		
		CommPortIdentifier.addPortName("COM3", CommPortIdentifier.PORT_SERIAL, null);
		CommPortIdentifier.addPortName("COM4", CommPortIdentifier.PORT_SERIAL, null);

    	// Obtain a CommPortIdentifier object for the port you want to open.
   		try {
        portId =
         CommPortIdentifier.getPortIdentifier(portname);
    	} catch (NoSuchPortException e) {
        	throw new TestBusException(e.getMessage());
    	}	

    	// Open the port represented by the CommPortIdentifier object. Give
    	// the open call a relatively long timeout of 30 seconds to allow
    	// a different application to reliquish the port if the user
    	// wants to.
    	try {
    	    sPort = (SerialPort)portId.open("ContestEntry201", 10000);
    	} catch (PortInUseException e) {
    	    throw new TestBusException(e.getMessage());
    	}

    	// Set connection parameters, if set fails return parameters object
    	// to original state.
    	try {
        	sPort.setSerialPortParams(19200,SerialPort.DATABITS_8,SerialPort.STOPBITS_2,SerialPort.PARITY_NONE);   
			sPort.setFlowControlMode(SerialPort.FLOWCONTROL_NONE );

    	} catch (UnsupportedCommOperationException e) {   
			sPort.close();
        	throw new TestBusException("Unsupported parameter");
    	}

    	// Open the input and output streams for the connection. If they won't
   		// open, close the port before throwing an exception.
    	try {
        	streamo = sPort.getOutputStream();
        	streami = sPort.getInputStream();
    	} catch (IOException e) {
        	sPort.close();
        	throw new TestBusException("Error opening I/O streams");
    	}
		
        sPort.setDTR(true);
        sPort.setRTS(true);

    	open = true;

	}

	/**
		Perform any cleanup operations
	*/
	public void clean()
	{
		if(open==true)
			sPort.close();
			
		open=false;
	}
	
		/**
		 * set the response timeout to wait for a pod to response
		 *
		 * @param n		The timeout in milliseconds
		 */
		public	void set_timeout(int n)
		{
			if(n < 1)
				n=1;
			timeout=n;
		}
	

	/**
	 * set the number of samples to take when measuring an analog input
	 *
	 * @param n		The number of samples (1..255)
	 * @exception	If the value is out of range
	 */
	public	void set_samples(int n)
		throws NumberFormatException
	{
		if(n < 1 || n > 255)
			throw new NumberFormatException("Samples is out of range");

		samples=n;
	}


	/**
	 * set the sampling frequency of analog inputs 
	 *
	 * @param hz	The sampling frequency (8..480 Hz)
	 * @exception	If the value is out of range
	 */
	public	void set_freq(int hz)
		throws NumberFormatException
	{
		if(hz < 8 || hz > 480)
			throw new NumberFormatException("Frequency is out of range");
			
		//
		// sampling freq = data clock / 65*256
		// data clock = 24M / divider
		// ie. divider = 24M / 65*256*sampling freq
		// 
		dividek = (int)(24.0e6 / (65*256*hz));
		
		//System.out.println("Divider = "+dividek);
		
		freq=hz;
	}


	/**
	** Set a single-ended digital output to a particular state
	**
	** @param	port	The port to drive (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7])
	** @param 	state	0=LO,1=HI
	** @param 	mode	0=Resistive 5.6K pulldown 1=CMOS 2=HighZ 3=Resistive 5.6K pullup
	** @exception TestBusException if there was a problem with the bus
	*/
	public void drive_digital_output(int port, int state, int mode)
		throws TestBusException
	{
		String cmd;
		
		cmd = "!"+(char)(((port>>5)&7)+'0')+"="+((port>>3)&3)+(port&7);
		
		if(state < 0 || state > 1)
			throw new TestBusException("Invalid state in drive_digital_output");
		
		if(mode < 0 || mode > 3)
			throw new TestBusException("Invalid mode in drive_digital_output");
		
		cmd = cmd + (char)(mode+'0') + (char)(state+'0') + endcmd;
		
		System.out.print(cmd);
		
		try {
			streamo.write(cmd.getBytes(),0,cmd.length());
			streamo.flush();
		} catch(IOException ioe) {
			throw new TestBusException(ioe.getMessage());
		}		
	}	

	/**
	** Set a double-ended digital output to a particular state
	**
	** @param	portp	The positive port to drive (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7])
	** @param	portn	The positive port to drive (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7])	
	** @param 	state	0=LO,1=HI
	** @param	mode	0=Open drain 1=CMOS 2=HighZ 3=Open collector
	** @exception TestBusException if there was a problem with the bus
	*/
	public void drive_digital_output(int portp,int portn, int state, int mode)
		throws TestBusException
	{
		if(portp >= 0)
			drive_digital_output(portp,state,mode);
		if(portn >= 0)
			drive_digital_output(portn,state ^ 1,mode);
	}	

	/**
	** Set a single-ended analog output into a particular state
	**
	** @param	port	The port to drive (B5..7=POD[0..7] B3..4=0 B0..2=BIT[0..7])
	** @param	value	The value to drive 0..1
	** @exception TestBusException if there was a problem with the bus
	*/
	public void drive_analog_output(int port, double value)
		throws TestBusException
	{
		String cmd;
		int ivalue = (int)(value*62.0);
		
		cmd = "!"+(char)(((port>>5)&7)+'0')+"W"+(port&7)+(char)(hex.charAt(ivalue>>4))+(char)(hex.charAt(ivalue&15))+endcmd;
		
		System.out.print(cmd);
		
		try {
			streamo.write(cmd.getBytes(),0,cmd.length());
			streamo.flush();
		} catch(IOException ioe) {
			throw new TestBusException(ioe.getMessage());
		}
			
    }

	/**
	** Set a double-ended analog output into a particular state
	**
	** @param	portp	The positive port to drive (B5..7=POD[0..7] B3..4=0 B0..2=BIT[0..7])
	** @param	portn	The positive port to drive (B5..7=POD[0..7] B3..4=0 B0..2=BIT[0..7])
	** @param	value	The value to drive 0..1
	** @exception TestBusException if there was a problem with the bus
	*/
	public void drive_analog_output(int portp, int portn, double value)
		throws TestBusException
	{
		if(portp >=0)
			drive_analog_output(portp,value);
		if(portn >=0)
			drive_analog_output(portn,1.0-value);
			
    }

	//
  	// Wait for data to be present on the input stream
	//
  	private boolean waitData(int bytes)
		throws TestBusException
  	{
    int gotbytes=0;
	int to=timeout;
	
    while((gotbytes < bytes) && (to > 0))
    {
		try {
	        gotbytes = streami.available();
		} catch(IOException ioe) {
			throw new TestBusException(ioe.getMessage());
		}

     if(gotbytes < bytes)
     {
	 	//System.out.println("Got "+gotbytes+" Expecting "+bytes+" Sleep "+to);
		
        try
            { // Snoozing a bit.
                Thread.sleep(10);
            }
            catch (Exception e)
            {
				throw new TestBusException("Couldn't sleep "+e.getMessage());
				
            }
        to -= 10;

      }
	 }
	 
	     return (gotbytes >= bytes);

    }

	/**
	** Read the state of a single-ended digital input
	**
	** @param port The port to test (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7])
	** @param force_input Whether to force the pin to an input first
	** @exception TestBusException if there was a problem with the bus
	** @return int indicating whether the input was high or low 
	*/
	public int read_digital_input(int port,boolean force_input)
		throws TestBusException
	{
		String cmd;
		
		 cmd = "!"+(char)(((port>>5)&7)+'0')+"?"+((port>>3)&3)+(port&7);

		 if(force_input)
		 	cmd = cmd + "1";
		 else
			cmd = cmd + "0";
			
		 cmd=cmd+endcmd;
		 
		 System.out.print(cmd);
			
		 try {
			streamo.write(cmd.getBytes(),0,cmd.length());
			streamo.flush();
			
			while(true==waitData(1))
			{
					streami.read(buffer,0,1);
					if(buffer[0]=='*')
					{
						if(true==waitData(1))
						{
							streami.read(buffer,1,1);
							return buffer[1]-'0';
						}
					}
			}
			throw new TestBusException("Timeout");
			
		} catch(IOException ioe) {
			throw new TestBusException(ioe.getMessage());

		}

	}
	
	/** 
	** Read the state of a single-ended or double-ended analog input
	**
	** @param port_p The positive port to test (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7]) (0=AGND)
	** @param port_n The negative port to test (B5..7=POD[0..7] B3..4=PORT[0..3] B0..2=BIT[0..7]) (0=AGND)
	** @param gaink The gain setting for the signal conditioning op-amp
	** @exception TestBusException if there was a problem with the bus
	** @return int analog value between -2047 and 2047
	*/
	public int read_analog_input(int port_p,int port_n, int gaink)
		throws TestBusException
	{
		String cmd,resp;
		int retval,unit=0;
		char cport_p,cport_n;
		
		// some sanity checks
		if(port_p >= 0 && port_n >= 0)
		{
		 if((port_p >> 5) != (port_n >> 5))
			throw new TestBusException("Analog positive and negative inputs must be on the same pod");
		}
		
		// determine port names
		if(port_p < 0)
			cport_p = '8';
		else
		{
			cport_p = (char)((port_p & 7)+'0');
			unit=(port_p >> 5)&7;
		}
		
		if(port_n < 0)
			cport_n = '8';
		else
		{
			cport_n = (char)((port_n & 7)+'0');
			unit=(port_n >> 5)&7;
		}
		
		cmd = "!"+(char)(unit+'0')+"R"+cport_p+cport_n ;
		
		cmd = cmd + hex.charAt(gaink>>4) + hex.charAt(gaink&15) ;
		cmd = cmd + hex.charAt(samples>>4) + hex.charAt(samples&15);			
		cmd = cmd + hex.charAt(dividek>>4) + hex.charAt(dividek&15);
		cmd = cmd + endcmd;
		
		System.out.print(cmd);
				
		try {
			streamo.write(cmd.getBytes(),0,cmd.length());
			streamo.flush();
			
			while(true==waitData(1))
			{
					streami.read(buffer,0,1);
						
					if(buffer[0]=='*')
					{
						
						if(true==waitData(4))
						{
							streami.read(buffer,1,4);
							
							resp = ""+(char)buffer[1]+(char)buffer[2]+(char)buffer[3]+(char)buffer[4];
							
							try {
								retval = Integer.parseInt(resp, 16);
							} catch(NumberFormatException nfe) {
								throw new TestBusException("Garbled response "+nfe.getMessage());
							}
							
							if(retval > 32767)
								retval = retval-65536;
															
							return retval;
						}					
					}
					
					
			}
			throw new TestBusException("Timeout");
			
		} catch(IOException ioe) {
			throw new TestBusException(ioe.getMessage());

		}			
	
	}

}
