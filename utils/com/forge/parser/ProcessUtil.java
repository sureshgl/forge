package com.forge.parser;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;

public class ProcessUtil {
	
	@Data
	@AllArgsConstructor
	public static final class ProcessGroup{
		private final Process process;
		private final StreamGobber stdoutReader, stderrReader;
	}
	
	public static ProcessGroup executeProcessBlocking(List<String> cmd, String dir) {
		return executeProcessBlocking(cmd, dir, true);
	}
	
	public static ProcessGroup executeProcessBlocking(List<String> cmd, String dir, boolean failOnError){
		return executeProcess(cmd, dir, null, true, failOnError);
	}
	
	public static ProcessGroup executeProcessNonBlocking(List<String> cmd, String dir){
		return executeProcess(cmd, dir, null, false, false);
	}
	
	
	public static ProcessGroup executeProcess(List<String> cmd, String dir, Map<String,String> env, boolean isBlocking, boolean failOnError) {
		try {
			ProcessGroup pg = RunProcess(cmd, dir, env, isBlocking);
			if(isBlocking && failOnError && pg.process.exitValue() != 0) {
			    throw new RuntimeException(pg.stdoutReader.getOutput());
			}
			return pg;
			
		} catch (Throwable t) {
			throw new RuntimeException(t.getMessage());
		}
	}
	
	private static ProcessGroup RunProcess(List<String> cmd, String dir, Map<String,String> env, boolean isBlocking) throws IOException, InterruptedException {	
		ProcessBuilder pb = new ProcessBuilder(cmd);
		pb.directory(new File(dir));
		if(env != null) pb.environment().putAll(env);
		
		Process p  = pb.start();
		StreamGobber stdoutReader = new StreamGobber(p.getInputStream());
		StreamGobber stderrReader = new StreamGobber(p.getErrorStream());
		
	    Thread pipeThread = new Thread(stdoutReader);
	    Thread errorThread = new Thread(stderrReader);
	    
	    pipeThread.start();
	    errorThread.start();
	   
	    if(isBlocking){
	    	p.waitFor();
	    	pipeThread.join();
	    	errorThread.join();
	    }
	    return new ProcessGroup(p, stdoutReader, stderrReader);
	}
	
	public static class StreamGobber implements Runnable {

	    private InputStream Pipe;
	    private StringBuilder output;

	    public String getOutput() {
	    	return output.toString();
	    }

	    public StreamGobber(InputStream pipe) {
	        Pipe = pipe;
	        output = new StringBuilder();
	    }

	    @Override
		public void run() {
	    	try {
	    		BufferedReader br = new BufferedReader(new InputStreamReader(Pipe));
	    		String s;
	    		while ((s = br.readLine()) != null) {
	    			output.append(s + "\n");
	    		}
	    	} catch (IOException e) {
	    		output.append(e.getMessage());
	        } finally {
	            if(Pipe != null) {
	            	try {
	                    Pipe.close();
	                } catch (IOException e) {
	                
	                }
	            }
	        }
	    }
	}
}
