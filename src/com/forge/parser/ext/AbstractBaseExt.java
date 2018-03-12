package com.forge.parser.ext;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.stringtemplate.v4.ST;

import com.forge.common.FileUtils;
import com.forge.parser.ExtendedContextVisitor;
import com.forge.parser.GetFormattedText;
import com.forge.parser.SemanticValidator;
import com.forge.parser.IR.IField;
import com.forge.parser.IR.IMemory;
import com.forge.parser.IR.IRegister;
import com.forge.parser.gen.ForgeLexer;
import com.forge.parser.gen.ForgeParser;
import com.forge.runner.ForgeRunnerSession;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

@Data
public abstract class AbstractBaseExt implements GetFormattedText, SemanticValidator {
	private static final Logger L = LoggerFactory.getLogger(AbstractBaseExt.class);
	// variables
	private ExtendedContextVisitor extendedContextVisitor;

	@Setter(AccessLevel.NONE)
	protected List<ParserRuleContext> contexts;
	protected ParserRuleContext parent;

	// abstract methods
	abstract public ParserRuleContext getContext();

	abstract public ParserRuleContext getContext(String str);

	abstract public void setContext(ParserRuleContext ctx);

	// constructor
	public AbstractBaseExt() {
		extendedContextVisitor = new ExtendedContextVisitor();
		contexts = new ArrayList<>();
	}

	public AbstractBaseExt getExtendedContext(ParseTree context) {
		if (context != null) {
			return extendedContextVisitor.visit(context);
		} else {
			return null;
		}
	}

	protected void addToContexts(ParserRuleContext context) {
		contexts.add(context);
		AbstractBaseExt extCtx = getExtendedContext(context);
		if (extCtx != null) {
			extCtx.contexts = contexts;
			extCtx.parent = parent;
		}
	}

	// This method is not exposed outside.
	protected ForgeParser getPrimeParser(String str) {
		ForgeLexer lexer = new ForgeLexer(new ANTLRInputStream(str));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		return new ForgeParser(tokens);
	}

	// getFormattedText() app
	@Override
	public String getFormattedText() {
		StringBuilder sb = new StringBuilder();
		Params params = new Params(getContext(), sb);
		params.setBeginingOfAlignemtText(getContext().start.getStartIndex());
		getFormattedText(params);
		// L.debug("output =\n" + sb.toString());
		return sb.toString().trim();

	}

	protected void getFormattedText(Params params) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (childCtx instanceof TerminalNode) {
					printTerminalNode((TerminalNode) childCtx, params);
				} else if (childCtx.getText().length() > 0) {
					params.setContext((ParserRuleContext) childCtx);
					Params thisCtxParams = getExtendedContext(childCtx).getUpdatedParams(params);
					getExtendedContext(childCtx).getFormattedText(thisCtxParams);
				}
			}
		}
	}

	@Data
	protected class Params {
		public Params(ParserRuleContext ctx, StringBuilder sb) {
			this.context = ctx;
			beginingOfAlignemtText = 0;
			input = ctx.start.getInputStream();
			this.stringBuilder = sb;
		}

		private ParserRuleContext context;
		private CharStream input;
		private StringBuilder stringBuilder;
		private int beginingOfAlignemtText;

		@Override
		public String toString() {
			StringBuilder sb = new StringBuilder();

			sb.append("Context = " + context.getClass().getSimpleName() + "\n" + context.getText());
			sb.append("\n");
			sb.append("Text = " + stringBuilder.toString());
			sb.append("\n");
			sb.append("start =" + beginingOfAlignemtText);
			sb.append("\n");
			return sb.toString();
		}

	}

	/*
	 * check if they are pointing to the same char stream, else it resets the params
	 * with the new char stream params.
	 */
	private Params getUpdatedParams(Params params) {

		if (getContext() == null) {
			// The item is removed during the transformation, hence skip its contents.
			String alignmentText = params.getInput().getText(
					new Interval(params.beginingOfAlignemtText, params.getContext().start.getStartIndex() - 1));
			params.getStringBuilder().append(alignmentText);
			params.setBeginingOfAlignemtText(params.getContext().stop.getStopIndex() + 1);
			return null;
		}
		if (getContext().start.getInputStream() != params.getContext().start.getInputStream()) {
			/*
			 * advance the begining of alignment text, as we are going to consider
			 * 'mostRecentContext' in its place.
			 */
			if (params.beginingOfAlignemtText < params.getContext().start.getStartIndex()) {
				String alignmentText = params.getInput().getText(
						new Interval(params.beginingOfAlignemtText, params.getContext().start.getStartIndex() - 1));
				params.getStringBuilder().append(alignmentText);
			}
			params.setBeginingOfAlignemtText(params.getContext().stop.getStopIndex() + 1);
			return new Params(getContext(), params.getStringBuilder());
		} else {
			params.setContext(getContext());
			return params;
		}
	}

	private void printTerminalNode(TerminalNode node, Params params) {
		CharStream input = params.getContext().start.getInputStream();
		if (node.getText().equals("<EOF>")) {
			String end = input.getText(new Interval(params.getBeginingOfAlignemtText(), input.size()));
			params.getStringBuilder().append(end);
		} else {
			if (params.getBeginingOfAlignemtText() < node.getSymbol().getStartIndex()) {
				Interval alignmentTextInterval = new Interval(params.getBeginingOfAlignemtText(),
						node.getSymbol().getStartIndex() - 1);
				String alignmentText = input.getText(alignmentTextInterval);
				params.getStringBuilder().append(alignmentText);
			}
			params.getStringBuilder().append(node.getText());
			params.setBeginingOfAlignemtText(node.getSymbol().getStopIndex() + 1);
		}
	}
	
	public void resolveParameters(Map<String,String> topModuleParameters){
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).resolveParameters(topModuleParameters);
				}
			}
		}
	}

	// implemented for VerilogGen
	public boolean isReadTrigger() {
		ParserRuleContext ctx = getContext();
		boolean isTriggerField = false;
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					isTriggerField = getExtendedContextVisitor().visit(childCtx).isReadTrigger();
					if (isTriggerField) {
						return isTriggerField;
					}
				}
			}
		}
		return isTriggerField;
	}

	public boolean isWriteTrigger() {
		ParserRuleContext ctx = getContext();
		boolean isTriggerField = false;
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					isTriggerField = getExtendedContextVisitor().visit(childCtx).isWriteTrigger();
					if (isTriggerField) {
						return isTriggerField;
					}
				}
			}
		}
		return isTriggerField;
	}

	public boolean isReadClear() {
		ParserRuleContext ctx = getContext();
		boolean isReadClear = false;
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					isReadClear = getExtendedContextVisitor().visit(childCtx).isReadClear();
					if (isReadClear) {
						return isReadClear;
					}
				}
			}
		}
		return isReadClear;
	}

	protected List<String> getMemNames(String prefix) {
		List<String> meminfos = new ArrayList<>();
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					List<String> meminfos_ = getExtendedContextVisitor().visit(childCtx).getMemNames(prefix);
					meminfos.addAll(meminfos_);
				}
			}
		}
		return meminfos;
	}

	protected List<String> getPortConnections(String name, Boolean banked) {
		List<String> ret = new ArrayList<>();
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					List<String> ret_ = getExtendedContextVisitor().visit(childCtx).getPortConnections(name, banked);
					ret.addAll(ret_);
				}
			}
		}
		return ret;
	}

	public void writeFile(ForgeRunnerSession forgeRunnerSession, ST module, String name, String extension) {
		File dir = forgeRunnerSession.getOutput();
		File outFile = new File(dir + "/" + name + extension);
		try {
			outFile.createNewFile();
		} catch (IOException e) {
			System.out.println("cannot create " + name + extension + "in out directory");
		}
		FileUtils.writeToFile(outFile, false, module.render());
	}

	// implemented for semantic checks
	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).duplicateNamesCheck(parentName, blockNames);
				}
			}
		}
	}

	// implemented for semantic checks
	@Override
	public void requiredPropertyCheck() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).requiredPropertyCheck();
				}
			}
		}
	}

	// implemeted for semantic checks
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).getSemanticInfo(propStore);
				}
			}
		}
	}

	public String getName(String name) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).getName(name);
				}
			}
		}
		return name;
	}

	// Implemented for semantic check to get datastructure names
	protected void getIdentifier(List<String> idList) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).getIdentifier(idList);
				}
			}
		}
	}

	// implemeted for semantic checks
	@Override
	public void arrayPropertyCheck() {
		arrayPropertyCheck(null);
	}

	// implemeted for semantic checks
	protected void arrayPropertyCheck(String parentName) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).arrayPropertyCheck(parentName);
				}
			}
		}
	}

	public void calculateRegisterOffset(AtomicInteger offset) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).calculateRegisterOffset(offset);
				}
			}
		}
	}

	public void calculateMemoryOffset(AtomicInteger offset) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).calculateMemoryOffset(offset);
				}
			}
		}
	}

	public void calculateHashtableOffset(AtomicInteger offset) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).calculateHashtableOffset(offset);
				}
			}
		}
	}

	public void calculateTcamOffset(AtomicInteger offset) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).calculateTcamOffset(offset);
				}
			}
		}
	}

	public void calculateFieldOffset(AtomicInteger offset) {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).calculateFieldOffset(offset);
				}
			}
		}
	}

	public void calculateOffset(AtomicInteger offset) {
		calculateFieldOffset(offset);
		offset = new AtomicInteger();
		calculateRegisterOffset(offset);
		calculateMemoryOffset(offset);
		calculateHashtableOffset(offset);
		calculateTcamOffset(offset);
	}

	public Boolean hasBanksInMemory() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					Boolean retFromChild = getExtendedContextVisitor().visit(childCtx).hasBanksInMemory();
					if (retFromChild) {
						return retFromChild;
					}
				}
			}
		}
		return false;
	}

	protected Integer getTotalRegisterSize() {
		// Sum of all the fields in the register
		ParserRuleContext ctx = getContext();
		Integer regTotalSize = 0;
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					regTotalSize += getExtendedContextVisitor().visit(childCtx).getTotalRegisterSize();
				}
			}
		}
		return regTotalSize;
	}

	protected Integer readPortValue() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					Integer readPortValue = getExtendedContextVisitor().visit(childCtx).readPortValue();
					if (readPortValue != null) {
						return readPortValue;
					}
				}
			}
		}
		return null;
	}

	protected Integer writePortValue() {
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					Integer writePortValue = getExtendedContextVisitor().visit(childCtx).writePortValue();
					if (writePortValue != null) {
						return writePortValue;
					}
				}
			}
		}
		return null;
	}

	protected List<IRegister> getRegisters() {
		ParserRuleContext ctx = getContext();
		List<IRegister> registerList = new ArrayList<>();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					registerList.addAll(getExtendedContextVisitor().visit(childCtx).getRegisters());

				}
			}
		}
		return registerList;
	}

	protected List<IMemory> getMemories() {
		ParserRuleContext ctx = getContext();
		List<IMemory> memoryList = new ArrayList<>();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					memoryList.addAll(getExtendedContextVisitor().visit(childCtx).getMemories());

				}
			}
		}
		return memoryList;
	}

	protected List<IField> getFields() {
		ParserRuleContext ctx = getContext();
		List<IField> fieldList = new ArrayList<>();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					fieldList.addAll(getExtendedContextVisitor().visit(childCtx).getFields());

				}
			}
		}
		return fieldList;
	}

	public static Logger getL() {
		return AbstractBaseExt.L;
	}
	
	public void collectModulesToStitchForTop(List<String> chain){
		ParserRuleContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			for (ParseTree childCtx : ctx.children) {
				if (!(childCtx instanceof TerminalNode) && childCtx.getText().length() > 0) {
					getExtendedContextVisitor().visit(childCtx).collectModulesToStitchForTop(chain);
				}
			}
		}
	}
}
