package com.forge.parser.ext;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IWords;
import com.forge.parser.gen.ForgeParser.WordsContext;

public class WordsContextExt extends AbstractBaseExt implements IWords {
	
	private static final Logger L = LoggerFactory.getLogger(WordsContextExt.class);

	public WordsContextExt(WordsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WordsContext getContext() {
		return (WordsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).words());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WordsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WordsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		WordsContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("words")) {
				propStore.put("words", ctx.id_or_number().extendedContext.getFormattedText());
			} else {
				throw new IllegalStateException(
						"Words" + " is duplicated in " + propStore.get("propName") + " in line " + ctx.start.getLine());
			}
		}
	}

	protected int offset;

	@Override
	public void calculateMemoryOffset(AtomicInteger offset) {
		WordsContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			Integer wc = null;
			try{
			wc = Integer.parseInt(ctx.id_or_number().extendedContext.getFormattedText());
			}
			catch(Exception e){
				L.error("Cannot parser String to Integer. Words at fault.");
				System.exit(1);
			}
			int aligned_wc = 1 << (int) (Math.log10(wc) / Math.log10(2));
			if (offset.get() % aligned_wc > 0) {
				offset.set(offset.get() + aligned_wc - offset.get() % aligned_wc);
			}
			this.offset = offset.get();
			offset.set(this.offset + aligned_wc);
		}
	}

	@Override
	public Integer getWords() {
		WordsContext ctx = getContext();
		try{
			return Integer.valueOf(ctx.id_or_number().extendedContext.getFormattedText());
		} catch(Exception e){
			L.error("Cannot parser String to Integer. Words at fault.");
			System.exit(1);
			return null;
		}
	}
}
